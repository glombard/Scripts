param (
    [string]$vhdFile
)

$vmDir = "$env:ProgramData\Hyper-V-Images"
$destDir = "$env:ProgramData\Hyper-V-Images\Virtual Hard Disks"

if (!$vhdFile) {
	Write-Host "Please specify the vhd filename parameter next time (e.g. Win7)..."
	Write-Host "Options:"
	[array]$options = Get-ChildItem "$destDir\*.vhd" | Resolve-Path | % { $_.ProviderPath }
	[int]$index = 0
	$options | % {
		$index++
		Write-Host "[$index]" (Split-Path $_ -Leaf) -BackgroundColor Black -ForegroundColor Magenta
	}
	$vhdFile = Read-Host "VMName or index"
	if ($vhdFile -match '^\d+$') {
		$vhdFile = $options[$vhdFile-1]
	}
}

if (!$vhdFile -or !(Test-Path $vhdFile)) {
	throw "Please specify the vhd filename!"
}

$VMName = Split-Path $vhdFile -Leaf
$VMName = $VMName -replace '\s',''
$VMName = $VMName -replace '\..*',''

Write-Host "Creating VM '$VMName' from $vhdFile" -BackgroundColor Black -ForegroundColor Cyan

$v = Get-VM $VMName -ErrorAction SilentlyContinue
if (!$v) {
	$switch = Get-VMSwitch -Name 'ExternalSwitch'
	if (!$switch) {
		$adapter = Get-NetAdapter -Name Ethernet
		if (!$adapter -or $adapter.Status -ne "Up") {
			New-VMSwitch -Name 'ExternalSwitch' -SwitchType Internal
		}
		else {
	    	$adapter | New-VMSwitch -Name 'ExternalSwitch'
		}
	}
    New-VM -Name $VMName -Path $vmDir -MemoryStartupBytes 2GB -VHDPath $vhdFile -SwitchName ExternalSwitch
}
else {
    Write-Host "VM $VMName already exists..."
}

$v = Get-VM | where Name -eq $VMName
if (!$v) {
	Write-Error "VM '$VMName' not created!"
	return
}
$vm = $v.Name
Write-Host "Using VM: $vm"

if ($v.State -ne 'Running') {
    Write-Host "Starting VM..."
 	Start-VM $vm   
}
