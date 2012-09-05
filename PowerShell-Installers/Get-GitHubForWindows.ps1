Write-Host "Installing GitHub for Windows ..."

function Test-Key([string]$path, [string]$key)
{
	if (!(Test-Path $path))
	{
		return $false
	}
	if ((Get-ItemProperty $path).$key -eq $null)
	{
		return $false
	}
	return $true
}

# see: http://blog.smoothfriction.nl/archive/2011/01/18/powershell-detecting-installed-net-versions.aspx
function Test-DotNet4Installed
{
	return Test-Key "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" "Install"
}

$instPath = "$env:LOCALAPPDATA\GitHub"
if (!(Test-Path $instPath))
{
    $file = "$env:TEMP\GitHubSetup.exe"
    if (Test-Path $file)
	{
		Write-Host "File already downloaded: $file"
	}
	else
    {
		$url = "http://github-windows.s3.amazonaws.com/GitHubSetup.exe"
		Write-Host "Downloading $url -> $file"
		$web = New-Object System.Net.WebClient
		$ua = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)'
		$web.Headers.Add('user-agent', $ua)	
		$web.DownloadFile($url, $file)
    }
    
    Write-Host "Installing..."

    $cmd = "$file /q"

    Invoke-Expression $cmd | Out-Null

    if (!(Test-DotNet4Installed))
    {
        Write-Host
        Write-Host ".NET Framework 4 Full is not installed."
        Write-Host "Please accept the EULA to install the .NET Framework 4..."
        Write-Host
        while (!(Test-DotNet4Installed))
        {
            Start-Sleep -Seconds 10
        }
    }

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
    Write-Host "GitHub for Windows already installed."
}
