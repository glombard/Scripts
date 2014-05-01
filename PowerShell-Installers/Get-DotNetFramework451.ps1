# Microsoft .NET 4.5.1
# See: http://www.microsoft.com/en-us/download/details.aspx?id=40779

function Invoke-Admin() {
    param ([string]$program, [string]$argumentString, [switch]$waitForExit)
    $psi = new-object "Diagnostics.ProcessStartInfo"
    $psi.FileName = $program 
    $psi.Arguments = $argumentString
    $psi.Verb = "runas"
    $proc = [Diagnostics.Process]::Start($psi)
    if ($waitForExit) {
        $proc.WaitForExit()
    }
}

$ver = (get-itemproperty "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version
if ($ver -match '4\.5') {
    Write-Host ".NET 4.5 already installed..."
    return
}

$file = 'NDP451-KB2858728-x86-x64-AllOS-ENU.exe'
$url = "http://download.microsoft.com/download/1/6/7/167F0D79-9317-48AE-AEDB-17120579F8E2/$file"
$output = Join-Path $env:Temp $file

$exists = $false
if (Test-Path $output) {
    $size = Get-Item $output | Select-Object -ExpandProperty Length
    if ($size -gt 60mb) {
        $exists = $true
    }
}
if ($exists) {
    Write-Host "Already exists: $output"
}
else {
    Write-Host "Downloading $output ..."
    $c = New-Object System.Net.WebClient
    $c.DownloadFile($url, $output)
}

Invoke-Admin $output '/q /norestart' $true

