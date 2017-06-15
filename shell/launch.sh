#!/bin/bash
#./launch.sh -u guest -pwd mypass -s test01.lab.opentext.com -p 80 -id 8 
#

port=80
home=$HOME

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
sample:./launch.sh -u guest -pwd stormY!12 -s test01.lab.opentext.com -p 80 -id 8 

help
exit 1
fi

userpass=${user}:${password}
uriEtxLauncher=`curl -v -u ${userpass} -X POST -H "Content-Type:application/json" http://${server}:${port}/etx/api/v2/sessions/launch/${id} | jq -r '.uriEtxLauncher'`

echo $uriEtxLauncher

#curl -v -u $uriEtxLauncher
xdg-open $uriEtxLauncher
