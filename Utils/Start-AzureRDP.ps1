# This starts the Azure VM if necessary and then starts the Remote Desktop connection...

param (
	[string]$name = $(Read-Host "Azure VM name")
)

$vm = Get-AzureVM -ServiceName $name
# Start the Azure Virtual Machine first:
if ($vm.PowerState -ne 'Started') {
	Start-AzureVM -Name $name -ServiceName $name
}

# Start Remote Desktop session:
$port = $vm | Get-AzureEndpoint -Name 'Remote Desktop' | select -ExpandProperty Port
$server = "${name}.cloudapp.net:$port"
Invoke-Expression "mstsc.exe /v:$server /f"
