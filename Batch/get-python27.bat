@echo off
setlocal

if exist "c:\Python27\python.exe" goto alreayInstalled

where curl
if errorlevel 1 (
	where cinst
	if errorlevel 1 powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin
	cinst curl	
)

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

echo Installing easy_install and virtualenv...
echo.
call curl -k -o%temp%\ez_setup.py https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
call curl -k -o%temp%\get-pip.py https://raw.github.com/pypa/pip/master/contrib/get-pip.py
call C:\Python27\python %temp%\ez_setup.py
call C:\Python27\python %temp%\get-pip.py
call C:\Python27\Scripts\easy_install virtualenv
call C:\Python27\Scripts\easy_install yolk
c:
cd C:\Python27\Scripts
yolk --list
goto :eof

:alreayInstalled
echo Python27 already installed.
goto :eof
