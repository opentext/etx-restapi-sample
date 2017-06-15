rem launch a profile 
rem usage: launch.cmd server:test01.lab.opentext.com port:80 user:guest pass:mypass id:9 

set port=80
set server=test01.lab.opentext.com
set user=
set pass=
set id=9

:parseparameters
IF "%~1"=="" GOTO launch
set param=%~1
for /F "tokens=1,2 delims=:" %%a in ("%param%") do (
    
  if "%%a"=="server" set server=%%b
  if "%%a"=="port" set port=%%b
  if "%%a"=="user" set user=%%b
  if "%%a"=="pass" set pass=%%b
  if "%%a"=="id" set id=%%b
)
SHIFT
GOTO parseparameters

:launch
set curlCmd=curl -v -u %user%:%pass% -X POST -H "Content-Type:application/json" http://%server%:%port%/etx/api/v2/sessions/launch/%id% 
set jqCmd=jq-win64.exe -r ".uriEtxLauncher" 
set pipeCmd="%curlCmd% | %jqCmd%"

FOR /F "tokens=* USEBACKQ" %%F IN (` %pipeCmd% `) DO (
SET uriEtxLauncher=%%F
)
echo %uriEtxLauncher%
#cmd /c 
start "" "%uriEtxLauncher%"



