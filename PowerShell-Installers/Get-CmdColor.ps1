param (
    [string]$target
)
$scriptDir = $MyInvocation.MyCommand.Path
if ($scriptDir) {
    $scriptDir = Split-Path $scriptDir
}
else {
    $scriptDir = $pwd
}
if (!$target) {
    $target = Join-Path $scriptDir "cmdcolor.exe"
}

if (!(Test-Path $target)) {
    $vc = "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin"
    $vcvars = "$vc\vcvars32.bat"
    if (!(Test-Path $vcvars)) {
        Write-Error "Can't find C++ compiler!"
    }
    else {
        Write-Host "Compiling cmdcolor..."
        $c = New-Object Net.WebClient
        $c.DownloadFile('https://raw.githubusercontent.com/jeremejevs/cmdcolor/master/cmdcolor.cpp', "$env:Temp\cmdcolor.cpp")
        $c.DownloadFile('https://raw.githubusercontent.com/jeremejevs/cmdcolor/master/build.bat', "$env:Temp\build.bat")
        Push-Location

        Set-Location $env:Temp

        [System.IO.File]::WriteAllText("$env:Temp\upx.cmd", "@echo off`necho Dummy UPX")

        if (!($env:Path -match '.VC.bin')) {
            Write-host updating path
            $env:Path += ";$vc"
        }

        & "$env:Temp\build.bat"

        Write-Host "Saving $target..."
        Copy-Item "$env:Temp\bin\tmp.exe" $target

        Pop-Location
    }
}
