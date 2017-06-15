#!/bin/bash
#./assignusertogroup.sh -u guest -pwd mypass -s test01.lab.opentext.com -p 80 -userGroupId 2 -userId 3

port=80
i=0
j=0
while [ "$1" != "" ]; do
	case $1 in
		-u | --user ) shift
			user=$1
			;;
		-pwd | --password ) shift
			password=$1
			;;								
		-s | --server ) shift
			server=$1
			;;
		-p | --port ) shift
			port=$1
			;;
		-userGroupId | --userGroupId ) shift
			userGroupId=$1
			;;
		-userId | --userId ) shift
			userId=$1
			;;	
	esac
    shift
done

if [[ -z "${user}" || -z "${password}" || -z "${server}" || -z "${userGroupId }" || -z "${userId }" ]]; then
cat <<help
-u,--user: username
-pwd,--password: password
-s,--server: server
-p,--port: port,default 80
-userGroupId,--userGroupId: user group id
-userId,--userId : new user id to add group
help
exit 1
fi

userpass=${user}:${password}


curl -u ${userpass} http://${server}:${port}/etx/api/v2/usergroups/${userGroupId} | jq '.' > tmpJsonGet.json
existingMembers=`jq -e -r '.members' tmpJsonGet.json`;

if [ "$existingMembers" = "" ] ; then
	members="$userId";
else
	members="$existingMembers,$userId";
fi

cat >tmpJsonPut.json<<jsonPut
{
  "members": "$members"
}

jsonPut

curl -v -u ${userpass} -X PUT -H "Content-Type:application/json" http://${server}:${port}/etx/api/v2/usergroups/${userGroupId} -d @tmpJsonPut.json

rm tmpJsonGet.json
rm tmpJsonPut.json
