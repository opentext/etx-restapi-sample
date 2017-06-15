Project Title

ETX Rest API Sample

Prerequisites

Windows:	
1.download curl from https://curl.haxx.se/download.html, for example,Win64 x86_64 zip	7.53.1
2.unzip curl.exe from "src" folder of curl-7.53.1.zip into c:\curl folder
3.add c:\curl into windows path
4.download jq from https://stedolan.github.io/jq/download/
5.add jq-win64.exe into windows path


Unix / Linux:	
install curl and jq with package install tools, such as yum, apt-get,rpm,wget,
for example:
sudo yum install curl 
sudo yum install jq
sudo apt-get install curl
sudo apt-get install jq

Download Open Text ETX Rest API Samples
1.download samples from https://github.com/opentext/etx-restapi-sample/
2.unzip sample file

Running the tests
go to sample folder and copy the sample uages in the beginning of the file.
for example,
Windows:
launch.cmd server:test01.lab.opentext.com port:80 user:guest pass:mypass id:9 
Unix/Linux:
./launch.sh -u guest -pwd mypass -s test01.lab.opentext.com -p 80 -id 8 


