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
	$switchName = 'ExternalSwitch'
	$switch = Get-VMSwitch -Name $switchName -ErrorAction SilentlyContinue
	if (!$switch) {
		$switch = Get-VMSwitch -SwitchType 'External' -ErrorAction SilentlyContinue
		if ($switch) {
			$switchName = $switch.Name
		}
	}
	if (!$switch) {
		$adapter = Get-NetAdapter -Name Ethernet
		if (!$adapter -or $adapter.Status -ne "Up") {
			New-VMSwitch -Name $switchName -SwitchType Internal
		}
		else {
	    	$adapter | New-VMSwitch -Name $switchName
		}
	}
    New-VM -Name $VMName -Path $vmDir -MemoryStartupBytes 2GB -VHDPath $vhdFile -SwitchName $switchName
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
