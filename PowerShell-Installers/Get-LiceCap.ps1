# Determine latest version's filename:

$url = 'http://www.cockos.com/licecap/'
$c = new-object Net.WebClient
$p = $c.DownloadString($url)
$m = $p | Select-String 'href="(.*?exe)"' -AllMatches
$files = $m.matches | % { $_.Groups[1].Value }
$version_files = @{}
$versions = @()
$files | foreach {
	$_ -match '\d+'
	$ver = $matches[0].PadRight(4, '0')
	$version_files.Add($ver, $_)
	$versions += $ver
}
$ver = $versions | Sort-Object -Descending | Select-Object -First 1
$file = $version_files[$ver]

if (!$file) {
	Write-Error "Can't find filename!"
}

$dest = Join-Path $env:TEMP $file
$url += $file
$c.DownloadFile($url, $dest)

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

Invoke-Admin $dest '/S' $true
