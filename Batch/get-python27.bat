@echo off
setlocal

if exist "c:\Python27\python.exe" goto alreayInstalled

REM Determine Python 2.7 download url:
for /f "usebackq" %%a in (`powershell -NoProfile -ExecutionPolicy unrestricted -Command "$u='http://python.org';(new-object net.webclient).DownloadString($u+'/download/') -match 'href=.(.*?python-2.*?msi)'|Out-Null;$u+$matches[1]"`) do set url=%%a

REM Extract the filename from the url:
for /f "tokens=6 delims=/" %%a in ("%url%") do set filename=%%a
set output=%temp%\%filename%
echo Downloadinging Python
echo from: %url%
echo   to: %output%
echo.

if exist "%output%" (
	echo %filename% already exists!
	goto startInstall
)
curl -o%output% %url%

:startInstall
echo Installing...
echo.

start /wait msiexec /i %output% /passive /norestart /log %temp%\python-install.log
set PATH=%PATH%;C:\Python27
set PATH=%PATH%;C:\Python27\Scripts
setx PATH "%PATH%" /m

goto :eof

:alreayInstalled
echo Python27 already installed.
goto :eof
