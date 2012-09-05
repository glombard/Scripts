Write-Host "Installing LastPass..."

function Download-LastPass
{
    param ([string]$file)
    
    if (Test-Path $file)
    {
        Write-Host "File already exists: $file"
    }
    else
    {
        $url = "http://download.lastpass.com/lastpass.exe"
        Write-Host "Downloading $url -> $file ..."
        $web = New-Object Net.WebClient
        $web.DownloadFile($url, $file)
    }
}

# see: http://stackoverflow.com/questions/1566969/showing-the-uac-prompt-in-powershell-if-the-action-requires-elevation
function Invoke-Admin() {
    param ( [string]$program = $(throw "Please specify a program" ),
            [string]$argumentString = "",
            [switch]$waitForExit )

    $psi = new-object "Diagnostics.ProcessStartInfo"
    $psi.FileName = $program 
    $psi.Arguments = $argumentString
    $psi.Verb = "runas"
    $proc = [Diagnostics.Process]::Start($psi)
    if ( $waitForExit ) {
        $proc.WaitForExit();
    }
}

function Install-LastPass
{
    param ([string]$file, [string]$instPath)
    
    Write-Host "Installing $file..."
    $args = "--elevate --userinstallie -userinstallff --installdir=""$env:ProgramFiles\LastPass"""
    
    Invoke-Admin $file $args $true
    
    while (!(Test-Path $instPath))
    {
        Write-Host "Waiting..."
        Start-Sleep -Seconds 10
    }
    
    Write-Host "Done!"
}

function Check-Administrator
{
    return (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
}

$instPath = "$env:ProgramFiles\LastPass\lastpass.exe"

if (Test-Path $instPath)
{
    Write-Host "LastPass already installed."
}
else
{
    if (-not (Check-Administrator))
    {
        Write-Host "Attempting to run as administrator ..."
    }

    $inst = "$env:TEMP\lastpass.exe"
    Download-LastPass $inst
    Install-LastPass $inst $instPath
}
