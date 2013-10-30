netsh advfirewall firewall set rule group="remote desktop" new enable=Yes 
powershell -File Set-Enable-RDP.ps1
