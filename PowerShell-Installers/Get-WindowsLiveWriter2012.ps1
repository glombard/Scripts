$appName = "Windows Live Writer 2012"
Write-Host "Installing $appName..."

$instPath = "${env:ProgramFiles(x86)}\Windows Live\Writer\WindowsLiveWriter.exe"
if (!(Test-Path $instPath))
{
    $file = "$env:TEMP\wlsetup-web.exe"
    if (Test-Path $file)
	{
		Write-Host "File already downloaded: $file"
	}
	else
    {
		$url = "http://go.microsoft.com/fwlink/?LinkID=255475"
		Write-Host "Downloading $url -> $file"
		$web = New-Object System.Net.WebClient
		$ua = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)'
		$web.Headers.Add('user-agent', $ua)	
		$web.DownloadFile($url, $file)
    }
    
    Write-Host "Installing..."

    $cmd = "$file /appselect:writer /quiet"

    Invoke-Expression $cmd | Out-Null

    Write-Host "Waiting for installation to complete..."
    while (!(Test-Path $instPath))
    {
        Start-Sleep -Seconds 10
    }

    Write-Host "Done!"
	
	Get-Item $file | rm -Force -ErrorAction 0 | Out-Null
}
else
{
    Write-Host "$appName already installed."
}
