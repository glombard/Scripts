@echo off

if not exist C:\Chocolatey goto InstChocolatey
echo Chocolatey already installed.
goto:eof

:InstChocolatey
echo Chocolatey installing ...
echo.
powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin
