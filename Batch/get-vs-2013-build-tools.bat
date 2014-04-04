@echo off

REM Downloads and installs Microsoft Build Tools 2013
REM see: http://www.microsoft.com/en-us/download/details.aspx?id=40760

setlocal
set output=%temp%\BuildTools_Full.exe
if exist "%output%" goto startInstall
set url=http://download.microsoft.com/download/9/B/B/9BB1309E-1A8F-4A47-A6C5-ECF76672A3B3/BuildTools_Full.exe
call curl -o%output% %url%
:startInstall
start /wait %output% /passive /full /norestart
