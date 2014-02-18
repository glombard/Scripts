# This scripts loads the cool posh-monokai.ps1 script from github.com/ntwb and
# runs it in each of the HKCU:\Console register sub-keys.

function Get-MonokaiScript() {
    Write-Host "Downloading posh-monokai.ps1 ..." -ForegroundColor Green
    $client = New-Object System.Net.WebClient
    $monokai = $client.DownloadString('https://github.com/ntwb/posh-monokai/raw/master/posh-monokai.ps1')
    return $monokai
}

function Set-MonokaiConsoleRegistry() {
    param (
        [string]$registryKey,
        [string]$monokaiScript
    )
    
    write-host "`nUpdating: $registryKey ..." -ForegroundColor Green

    $script = $monokaiScript.Replace(".\Windows PowerShell", $registryKey)
    iex $script
}

function Get-ChocolateyInstall() {
    if (!(Test-Path $env:SystemDrive\Chocolatey\chocolateyinstall\chocolatey.ps1)) {
        Write-Host "Installing Chocolatey ..."
        Set-ExecutionPolicy Unrestricted
        iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
    }
}

function Get-SourceCodePro() {
    if (!(Test-Path $env:SystemRoot\Fonts\SourceCodePro-Black.*)) {
        Get-ChocolateyInstall
        Set-ExecutionPolicy Unrestricted
        . $env:SystemDrive\Chocolatey\chocolateyinstall\chocolatey.ps1 install SourceCodePro
        # TODO: Chocolatey installs the OTP fonts only, I think we need the TTF versions...
    }
}

$monokaiScript = Get-MonokaiScript

Push-Location
Set-Location HKCU:\Console

if (!(Test-Path ".\Windows PowerShell")) {
    New-Item ".\Windows PowerShell"
}

$keys = dir | Resolve-Path -Relative
$keys += "." # TODO: I'm not sure if this one is necessary...
$keys += ".\Windows PowerShell" # TODO: not sure about this one either...
$keys | % { Set-MonokaiConsoleRegistry $_ $monokaiScript }
Pop-Location

$Host.PrivateData.DebugBackgroundColor = "DarkGray"
$Host.PrivateData.ErrorBackgroundColor = "DarkGray"

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" -Name 000 -Type String -Value "Source Code Pro" -ErrorAction SilentlyContinue
if (!$?) {
    Write-Host "`nWarning: couldn't set 'Source Code Pro' as console font in the Registry." -ForegroundColor Yellow
}

Get-SourceCodePro

# TODO: this seems to work for Git Shell but not the standard PowerShell prompt...
