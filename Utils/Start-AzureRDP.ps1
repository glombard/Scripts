# This starts the Azure VM if necessary and then starts the Remote Desktop connection...

param (
	[string]$name = $(Read-Host "Azure VM name")
)

$vm = Get-AzureVM | where { $_.ServiceName -eq $name }
if (!$?) {
    Add-AzureAccount
    $vm = Get-AzureVM -ServiceName $name
}

if ($vm -eq $null) {
    Write-Host "No such VM - $name"
    Exit
}

# Start the Azure Virtual Machine first:
if ($vm.PowerState -ne 'Started') {
    Write-Host "Starting $name ..."
	$vm | Start-AzureVM
}

# Start Remote Desktop session:
$port = $vm | Get-AzureEndpoint -Name 'Remote Desktop' | select -ExpandProperty Port
$server = "${name}.cloudapp.net:$port"
Invoke-Expression "mstsc.exe /v:$server /f"
