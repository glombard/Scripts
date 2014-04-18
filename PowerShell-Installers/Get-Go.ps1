# Installs the nice 'go' command into PowerShell. This allows bookmarking directories.

(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
Import-Module PsGet
Install-Module go -force
