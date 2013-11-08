@echo off
REM This installs .NET 2.0 SP2 and PowerShell on Windows XP SP3. (hello@gertlombard.com)
setlocal

if exist C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe goto psinstalled

echo Downloading 7za.exe and cURL...
set curl=%temp%\curl-7.19.3\curl.exe
set pssetup=%temp%\WindowsXP-KB968930-x86-ENG.exe
if not exist "%temp%\7za.exe" call :ftpget ftp.cadwork.ch /DVD_V17/CADWORK.DIR/COM/ 7za.exe
if not exist "%curl%" call :ftpget ftp.gr.freebsd.org /pub/net/ftp/curl/ curl-7.19.3-win32-nossl.zip
if not exist "%curl%" "%temp%\7za" x -y -o"%temp%\" curl-7.19.3-win32-nossl.zip
if not exist "%pssetup%" "%curl%" -o"%pssetup%" http://download.microsoft.com/download/E/C/E/ECE99583-2003-455D-B681-68DB610B44A4/WindowsXP-KB968930-x86-ENG.exe
if not exist "%pssetup%" goto downloadError

if exist C:\windows\Microsoft.NET\Framework\v2.0.50727\System.dll goto dotNetInstalled
"%curl%" -o"%temp%\NetFx20SP2_x86.exe" http://download.microsoft.com/download/c/6/e/c6e88215-0178-4c6c-b5f3-158ff77b1f38/NetFx20SP2_x86.exe
start /wait "Installing .NET" "%temp%\NetFx20SP2_x86.exe" /qb
set tries=
:dotNetCheck
if exist C:\windows\Microsoft.NET\Framework\v2.0.50727\System.dll goto dotNetDone
set tries=%tries%.
if "%tries%"=="...." goto dotNetError
ping 1.1.1.1 -n 1 -w 5000>nul
goto dotNetCheck
:dotNetDone
echo .NET 2.0 installed.
:dotNetInstalled

echo Starting PowerShell install...
start /wait "Installing PowerShell" "%pssetup%" /passive /log:"%temp%\powershell-install.log"
set tries=
:checkInstalled
if exist C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe goto psinstalled
set tries=%tries%.
if "%tries%"=="...." goto installError
ping 1.1.1.1 -n 1 -w 3000>nul
goto checkInstalled

:psinstalled
echo PowerShell installed.
goto :eof

:dotNetError
echo Error: Couldn't download .NET Framework!
goto :eof

:installError
echo Error: I'm not sure if the install worked!
goto :eof

:downloadError
echo Couldn't download the PowerShell installer to:
echo %pssetup%
goto :eof

:ftpget
set ftpscript=%temp%\ftp.txt
echo open %1>%ftpscript%
echo user>>%ftpscript%
echo anonymous>>%ftpscript%
echo.>>%ftpscript%
echo cd %2>>%ftpscript%
echo bin>>%ftpscript%
echo hash>>%ftpscript%
echo lcd %temp%>>%ftpscript%
echo get %3>>%ftpscript%
echo bye>>%ftpscript%
ftp -i -n -s:%temp%\ftp.txt
goto :eof
