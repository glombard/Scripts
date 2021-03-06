# steps:
# 1. run this file to generate angular.txt
# 2. upload angular.txt to http://myurl/box/
# 3. deploy with URL: http://boxstarter.org/package/nr/url?http://myurl/box/angular.txt

function Generate {
	$scriptPath = '.' #Split-Path -Parent $MyInvocation.MyCommand.Definition
	$functionsText = ""
	Resolve-Path $scriptPath\functions\*.ps1 | % {
		Write-Host "+" $_.ProviderPath
		$functionsText += (Get-Content $_.ProviderPath) -join [Environment]::NewLine
		$functionsText += [Environment]::NewLine
	}
	$setupText = (Get-Content setup.ps1) -join [Environment]::NewLine
	$setupText = $setupText.Replace('Resolve-Path $scriptPath\functions\*.ps1 | % { . $_.ProviderPath }',$functionsText)
	$dest = "angular.txt"
	Set-Content $dest $setupText -Force
	Write-Host "Generated '$dest'" -BackgroundColor Black -ForegroundColor DarkGreen
	Write-Host "`nNOTE: now upload '$dest' to http://myurl ..." -BackgroundColor Black -ForegroundColor Magenta
}

Generate
