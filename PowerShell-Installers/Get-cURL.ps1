function Unzip-File
{
    param ([string]$zipFile, [string]$destFolder)
    
    $7z = "$env:ProgramFiles\7-Zip\7za.exe"
    if (Test-Path $7z)
    {
        $info = New-Object Diagnostics.ProcessStartInfo
        $info.FileName = $7z
        $info.Arguments = "x -y -o""$destFolder"" ""$zipFile"""
        $info.Verb = "runas"
        $proc = [Diagnostics.Process]::Start($info)
        $proc.WaitForExit()
    }
    else
    {
        $shell = New-Object -Com Shell.Application
    	$zip = $shell.NameSpace($zipFile)
        $shell.NameSpace($destFolder).CopyHere($zip.Items(), 16)
    }
}

Write-Host "Installing cURL..."
$wc = New-Object Net.WebClient
$url = "http://www.paehl.com/open_source/?download=curl_732_0_ssl.zip"
$file = "$env:TEMP\curl.zip"
$wc.DownloadFile($url,$file)
Write-Host "Unzipping to: $env:windir"
Unzip-File $file $env:windir
Remove-Item $file
