$file = Join-Path $env:Temp wds_current_setup.exe
$url = 'https://windirstat.info/wds_current_setup.exe'
(new-object net.webclient).DownloadFile($url, $file)

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

Invoke-Admin $file '/S' $true
