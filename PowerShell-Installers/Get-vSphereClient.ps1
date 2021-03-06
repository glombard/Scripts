# VMware doesn't publicly announce the direct URLs for the vsphere Client install.
# Instead you get the 'Download vSphere Client' link from your ESX server.

function Set-IgnoreSSLTrust
{
    # See: http://blogs.technet.com/b/bshukla/archive/2011/12/13/3324650.aspx
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    
    $netAssembly = [Reflection.Assembly]::GetAssembly([System.Net.Configuration.SettingsSection])
     
    if ($netAssembly)
    {
        $bindingFlags = [Reflection.BindingFlags] "Static,GetProperty,NonPublic"
        $settingsType = $netAssembly.GetType("System.Net.Configuration.SettingsSectionInternal")
     
        $instance = $settingsType.InvokeMember("Section", $bindingFlags, $null, $null, @())
     
        if ($instance)
        {
            $bindingFlags = "NonPublic","Instance"
            $useUnsafeHeaderParsingField = $settingsType.GetField("useUnsafeHeaderParsing", $bindingFlags)
     
            if ($useUnsafeHeaderParsingField)
            {
                $useUnsafeHeaderParsingField.SetValue($instance, $true)
            }
        }
    }
}

function Test-FileAvailable
{
    param ([string]$fileName)
    $fileInfo = New-Object IO.FileInfo $fileName
    try
    {
        $file = $fileInfo.Open([IO.FileMode]::Open, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None);
        $file.Close();
    }
    catch
    {
        return $false
    }
    return $true
}

Write-Host "Installing vSphere Client ..."
$instPath = "${env:ProgramFiles(x86)}\VMware\Infrastructure\Virtual Infrastructure Client\Launcher\VpxClient.exe"
if (!(Test-Path $instPath))
{
    $localServer = Read-Host "Enter URL of local VMWare ESX server where the 'Download vSphere Client' can be found: "
    
    Write-Host "Determining download URL ..."
    $web = New-Object Net.WebClient
    Set-IgnoreSSLTrust
    $page = $web.DownloadString($localServer)

    $url = $page | Select-String -Pattern "(http://.*?\.exe)" | Select-Object -ExpandProperty Matches -First 1 | foreach { $_.Value }
	if (!($url))
	{
		$url = $localServer + "/client/VMware-viclient.exe"
	}
	
    $file = $url | Select-String -Pattern "([^/]+)$" | Select-Object -ExpandProperty Matches -First 1 | foreach { $_.Value }
   
    $destFile = "$env:TEMP\$file"
    if (Test-Path $destFile)
    {
        Write-Host "$destFile already exists ..."
    }
    else
    {
        Write-Host "Downloading $url -> $destFile"
        $web.DownloadFile($url, $destFile)
    }

    Write-Host "Extracting..."
    $cmd = "$destFile /x /d ""$env:TEMP\vSphereClient\"""
    Invoke-Expression $cmd | Out-Null
    
    Start-Sleep -Seconds 5
    $instFile = "$env:TEMP\vSphereClient\bin\VMware-viclient.exe"
    while (!(Test-FileAvailable $instFile))
    {
        Start-Sleep -Seconds 5
    }
    
    Write-Host "Installing $instFile ..."
    # See: http://www.vmware.com/files/pdf/techpaper/vsp_41_vcserver_cmdline_install.pdf
    $cmd = "$instFile /q /s /w /L1033 /v"" /qr"""
    Invoke-Expression $cmd | Out-Null
    
    while (!(Test-Path $instPath))
    {
        Start-Sleep -Seconds 10
    }

    Write-Host "Done!"
}
else
{
    Write-Host "vSphere Client already installed."
}
