# This scripts loads the cool posh-monokai.ps1 script from github.com/ntwb and
# runs it in each of the HKCU:\Console register sub-keys.

function Get-MonokaiScript {
    Write-Host "Downloading posh-monokai.ps1 ..." -ForegroundColor Green
    $client = New-Object System.Net.WebClient
    $monokai = $client.DownloadString('https://github.com/ntwb/posh-monokai/raw/master/posh-monokai.ps1')
    return $monokai
}

function Set-MonokaiConsoleRegistry {
    param (
        [string]$registryKey,
        [string]$monokaiScript
    )
    
    write-host "`nUpdating: $registryKey ..." -ForegroundColor Green

    $script = $monokaiScript.Replace(".\Windows PowerShell", $registryKey)
    iex $script
}

function Install-PoshMonokai {
    $monokaiScript = Get-MonokaiScript

    Push-Location
    Set-Location HKCU:\Console

    if (!(Test-Path ".\Windows PowerShell")) {
        New-Item ".\Windows PowerShell"
    }

    $keys = dir | Resolve-Path -Relative
    #$keys += "." # TODO: I'm not sure if this one is necessary...
    #$keys += ".\Windows PowerShell" # TODO: not sure about this one either...
    $keys | % { Set-MonokaiConsoleRegistry $_ $monokaiScript }
    
    Pop-Location

    $Host.PrivateData.DebugBackgroundColor = "DarkGray"
    $Host.PrivateData.ErrorBackgroundColor = "DarkGray"

    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" -Name 000 -Type String -Value "Source Code Pro" -ErrorAction SilentlyContinue
    if (!$?) {
        Write-Host "`nWarning: couldn't set 'Source Code Pro' as console font in the Registry." -ForegroundColor Yellow
    }
}
