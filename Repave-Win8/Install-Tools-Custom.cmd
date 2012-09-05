@echo off

set ps=..\PowerShell-Installers
call %ps%\Set-Execution-Policy.cmd
powershell -file %ps%\Set-VisualStudio2012-Menu-Caps.ps1
powershell -file %ps%\Set-Disable-HideFileExt.ps1
powershell -file %ps%\Get-LastPass.ps1
powershell -file %ps%\Get-ExamDiffPro.ps1
powershell -file %ps%\Get-GitHubForWindows.ps1
powershell -file %ps%\Get-WindowsLiveWriter2012.ps1
