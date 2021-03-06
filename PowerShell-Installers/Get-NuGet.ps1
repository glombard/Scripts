# This downloads the NuGet 2.0 Bootstrapper from: http://nuget.codeplex.com/downloads/get/412077

Write-Host "NuGet 2.0 ..."

function Get-RegexFirstGroup
{
    param ([string]$text, [string]$pattern)
    return $text | Select-String -Pattern $pattern | Select-Object -ExpandProperty Matches -First 1 | foreach { $_.Groups[1].Value }
}

function Download-File
{
	param (
            [string]$url, 
            [string]$file,
            [switch]$alwaysDownload = $false)
            
	Write-Host "Downloading: $url"
	Write-Host "to $file ..."
	
    if (($alwaysDownload -or (-not(Test-Path $file))))
    {
        $web = New-Object System.Net.WebClient
    	$web.DownloadFile($url, $file)
    }
    else
    {
        Write-Host "File already exists, skipping download."
    }
}

function Get-WebPage
{
    param ([string]$url, [Net.CookieContainer]$cookies)
    
    Write-Host "Getting $url ..."
    
    $req = [Net.WebRequest]::Create($url)
    $req.CookieContainer = $cookies
    $resp = [Net.HttpWebResponse]$req.GetResponse()
    $stream = $resp.GetResponseStream()
    $reader = New-Object IO.StreamReader $stream
    $page = $reader.ReadToEnd()
    $reader.Close()
    $stream.Close()
    $resp.Close()
    return $page
}

function Post-WebPage
{
    param ([string]$url, [string]$postStr, [Net.CookieContainer]$cookies)

    Write-Host "Posting to $url ..."

    $postData = [Text.Encoding]::UTF8.GetBytes($postStr)

    $req = [Net.WebRequest]::Create($url)
    $req.Method = "POST"
    $req.ContentType = "application/x-www-form-urlencoded"
    $req.ContentLength = $postData.Length
    $req.CookieContainer = $cookies

    $stream = $req.GetRequestStream()
    $stream.Write($postData, 0,$postData.length)
    $stream.Close()

    $resp = [Net.HttpWebResponse]$req.GetResponse()
    $stream = $resp.GetResponseStream()
    $reader = New-Object IO.StreamReader $stream
    $page = $reader.ReadToEnd()
    $reader.Close()
    $stream.Close()
    $resp.Close()
    return $page
}

function Get-CodeplexFile
{
    param ([string]$project, [string]$fileId, [string]$destFile)
    
    $cookies = New-Object Net.CookieContainer
    $url = "http://$project.codeplex.com/downloads/get/$fileId"
    $page = Get-WebPage $url $cookies
    $token = Get-RegexFirstGroup $page 'RequestVerificationToken.*?value="(.*?)"'
    if ($token)
    {
        Write-Host "Found token: $token"
        
        [Reflection.Assembly]::LoadWithPartialName("System.Web") | Out-Null 
        $token = [Web.HttpUtility]::UrlEncode($token)

        $postStr = "fileId=$fileId&clickOncePath=&allowRedirectToAds=false&__RequestVerificationToken=$token"
        $url = "http://$project.codeplex.com/releases/captureDownload"
        $page = Post-WebPage $url $postStr $cookies
        $url = Get-RegexFirstGroup $page '"(http.*?)"'

        Download-File $url $destFile
    }
    else
    {
        Write-Host "There seems to be a problem."
        Write-Host "Couldn't extract the token from the webpage at $url"
    }
}

function Download-NuGetBootstrapper
{
	param ([string]$file) 
    
    $project = "nuget"
    $fileId = "412077"
    Get-CodeplexFile $project $fileId $file
}

function Launch-Installer([string] $instFile)
{
	Write-Host "NuGet Installing ..."

    $env:EnableNuGetPackageRestore = $true
	Invoke-Expression $instFile | Out-Null
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

md "$env:TEMP\inst" -ErrorAction SilentlyContinue | Out-Null
$file = "$env:TEMP\inst\nuget.exe"
Download-NuGetBootstrapper $file
Launch-Installer $file
Write-Host "Copying to $env:windir ..."
Invoke-Admin 'robocopy' "$env:TEMP\inst $env:windir nuget.exe /mov /xo" $true
