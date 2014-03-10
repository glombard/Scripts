# Windows Software Development Kit (SDK) for Windows 8.1

$url = 'http://www.microsoft.com/click/services/Redirect2.ashx?CR_EAC=300135395'
$setupFile = Join-Path $env:TEMP sdksetup.exe
$web = New-Object System.Net.WebClient
$ua = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)'
$web.Headers.Add('user-agent', $ua)
$web.DownloadFile($url, $setupFile)

$dir = Join-Path $env:TEMP Windows-8.1-SDK

Invoke-Expression "$dest /quiet /layout $dir"

function Report()
{
    param ([string]$status)
    Write-Progress -Activity "Preparing Windows 8.1 SDK" -status $status $i" -percentComplete 50
}

# todo: this is still a work in progress...
