function Unzip-File
{
    param ([string]$zipFile, [string]$destFolder)
    $shell = New-Object -Com Shell.Application
    New-Item -ItemType Directory -Force -Path $destFolder
    $zip = $shell.NameSpace($zipFile)
    $shell.NameSpace($destFolder).CopyHere($zip.Items(), 16)
}

Write-Host "Installing 7-Zip Command Line (7za)..."
$dest = "$env:ProgramFiles\7-Zip"
$destFile = "$env:ProgramFiles\7-Zip\7za.exe"
if (!(Test-Path $destFile))
{
    Write-Host "Downloading 7za..."
    $wc = New-Object Net.WebClient
    $url = 'http://downloads.sourceforge.net/sevenzip/7za920.zip'
    $file = "$env:TEMP\7za920.zip"
    $wc.DownloadFile($url,$file)
    Write-Host "Unzipping to: $dest"
    Unzip-File $file $dest
    Remove-Item $file
}
else
{
    Write-Host "7za already installed."
}