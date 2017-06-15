@echo off
rem update profile attributes
rem usage: updateprofile.cmd server:test01.lab.opentext.com port:80 user:guest pass:mypass id:9 TargetNode:"Single^>www.test.com" EnableLog:0
set port=80
set server=test01.lab.opentext.com
set user=
set pass=
set id=
set jsonAttributes=""

SETLOCAL EnableDelayedExpansion
:parseparameters
IF "%~1"=="" GOTO curlPut
set param=%~1
for /F "tokens=1,2 delims=:" %%a in ("%param%") do (
	if "%%a"=="server" (
		set server=%%b
		goto :break
	)
	if "%%a"=="port" (
		set port=%%b
		goto :break
	)
	if "%%a"=="user" (
		set user=%%b
		goto :break
	)
	if "%%a"=="pass" (
		set pass=%%b
		goto :break
	)
	if "%%a"=="id" (
		set id=%%b
		goto :break
	)
	rem all others input parameters are attribute name and value
	
	if !jsonAttributes!=="" (
		set "jsonAttributes={"name":"%%a","value":%%b}"
	) else (
		set "jsonAttributes=!jsonAttributes!,{"name":"%%a","value":%%b}"
	)

)
:break
SHIFT
GOTO parseparameters


:curlPut
set jsonPut={"attributes":[!jsonAttributes!]}
echo %jsonPut% | curl -v -u %user%:%pass% -X PUT -H "Content-Type:application/json" http://%server%:%port%/etx/api/v2/profiles/%id% -d @-
endlocal



