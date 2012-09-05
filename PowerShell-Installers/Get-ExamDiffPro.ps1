Write-Host "Installing ExamDiff Pro ..."

$instPath = "$env:ProgramFiles\ExamDiff Pro\ExamDiff.exe"
if (!(Test-Path $instPath))
{
    Write-Host "Determining download URL ..."
    $web = New-Object System.Net.WebClient
    $ua = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)'
    $web.Headers.Add('user-agent', $ua)

    $page = $web.DownloadString("http://www.prestosoft.com/edp_download.asp")

    $bits = '32'
    if ($env:PROCESSOR_ARCHITECTURE -match '64')
    {
        $bits = '64'
    }

    $pattern = "file=(.*?${bits}.*?\.exe)"
    $url = $page | Select-String -Pattern $pattern | Select-Object -ExpandProperty Matches -First 1 | foreach { $_.Groups[1].Value }
    $url = "http://www.prestosoft.com/download/$url"

    $file = "$env:TEMP\edpro.exe"
    if (Test-Path $file)
    {
        Get-Item $file | rm -Force -ErrorAction 0 | Out-Null
    }
    
    Write-Host "Downloading $url -> $file ..."

    $web.DownloadFile($url, $file)

    Write-Host "Installing..."

    $cmd = "$file /silent"

    Invoke-Expression $cmd | Out-Null

    while (!(Test-Path $instPath))
    {
        Start-Sleep -Seconds 10
    }

    Write-Host "Done!"
}
else
{
    Write-Host "ExamDiff Pro already installed."
}
