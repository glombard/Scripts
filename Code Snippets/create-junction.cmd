@echo off
setlocal
set dest=%home%\Documents\Visual Studio 2013\Code Snippets\Visual C#
rd /s "%dest%"
mklink /j "%dest%" "%~dp0\Visual C#"
