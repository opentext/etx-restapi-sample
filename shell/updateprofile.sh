#!/bin/bash
#sample:./updateprofile.sh -u username -pwd password -s etx.mycompany.org -p 80 -id 18 -n1 TargetNode -v1 "Single>www.test.com" -n2 EnableLog -v2 0 -n3 LogFont -v3 1

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
		-id | --id ) shift
			id=$1
			;;
		-f | --file ) shift
			file=$1
			;;	
		-n[1-999] | --name[1-999] ) shift
			names[${i}]=$1
			i=$(( $i + 1 ))
			;;
		-v[1-999] | --value[1-999] ) shift
			values[${j}]=$1
			j=$(( $j + 1 ))
			;;
	esac
    shift
done

if [[ -z "${user}" || -z "${password}" || -z "${server}" || -z "${id}" ]]; then
cat <<help
-u,--user: username
-pwd,--password: password
-s,--server: server
-p,--port: port,default 80
-id,--id: profile id
-n1,--name1 : attribute name, replace variable hoder(#{n1},#{n2},#{n3}) in json file
-v1,--value1 : attribute value, replace variable hoder(#{v1},#{v2},#{v3}) in json file
help
exit 1
fi

userpass=${user}:${password}

for (( k=0; k<$i; k++ ))
do
attribute=$(cat <<jsonAttribute
	{
	  "name": "${names[k]}",
	  "value": "${values[k]}"
	},
jsonAttribute
)
attributes=$attributes$attribute	
done
attributes=${attributes::-1}

cat >tmpJsonPut.json<<jsonPut
{
  "attributes": [
		$attributes
  ],
  "id": "$id"
}

jsonPut


curl -v -u ${userpass} -X PUT -H "Content-Type:application/json" http://${server}:${port}/etx/api/v2/profiles/${id} -d @tmpJsonPut.json

rm tmpJsonPut.json
