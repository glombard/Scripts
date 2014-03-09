@echo off

REM this adds the Git\bin to powershell path to make Posh-git work...

set out=%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
set tmp=%TEMP%\set-git-bin.txt
set tmp2=%TEMP%\set-git-bin2.txt

find /c "Git\bin" %out% > nul 2> nul
if not errorlevel 1 goto alreadyOk

echo $env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin" > %tmp%
echo. >> %tmp%

echo Updating '%out%'...
copy /b %tmp%+%out% %tmp2% > nul
move /y %tmp2% %out%

goto:eof

:alreadyOk
echo.
echo Profile already sets Git path (%out%)
echo.
goto:eof
