function Install-VisualStudio {
	if (Test-Path HKLM:\Software\Microsoft\VisualStudio\12.0) {
		Write-Host "Visual Studio 2013 found..."
		return
	}
	
	if (Test-Path HKLM:\Software\Microsoft\VisualStudio\11.0) {
		Write-Host "Visual Studio 2012 found..."
		return
	}

	# For VS2012:	
	# cinst VisualStudio2012WDX
	
	# Download and install VS2013 Express...
	# http://www.microsoft.com/en-us/download/details.aspx?id=40787

	$dest = "$env:TEMP\VS2013_RTM_DskExp_ENU.iso"
	if (!(Test-Path $dest)) {
		Write-Host "Downloading Visual Studio 2013 Desktop Express..."
		curl.bat -o "$dest" http://download.microsoft.com/download/7/2/E/72E0F986-D247-4289-B9DC-C4FB07374894/VS2013_RTM_DskExp_ENU.iso
	}
	if (!(Get-DiskImage -ImagePath $dest -ErrorAction SilentlyContinue)) {
		Mount-DiskImage -ImagePath $dest
	}
	$drive = (Get-DiskImage -ImagePath $dest | Get-Volume).DriveLetter
	Write-Host "Mounted VS iso to drive $drive, now installing..."
	$setupFile = "$drive`:\wdexpress_full.exe"
	if (!(Test-Path $setupFile)) {
		Start-Sleep -Milliseconds 1000
	}
	if (!(Test-Path $setupFile)) {
		Write-Error "Can't find: $setupFile"
		return
	}
	Start-Process $setupFile -Wait -ArgumentList "/Passive","/NoRestart"
}
