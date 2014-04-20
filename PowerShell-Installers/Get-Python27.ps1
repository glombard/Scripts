$c = (new-object net.webclient)

if (!(Test-Path "c:\Python27\python.exe")) {
	Write-Host "Installing Python..."
	$u = 'http://python.org'
	$c.DownloadString($u+'/download/') -match 'href=.(.*?python-2.*?msi)' | Out-Null	
	$path = $matches[1]
	$url = $u + $path
	
	$path -match '\/([^/]*)$' | Out-Null
	$filename = $matches[1]
	$output = Join-Path $env:Temp $filename
	
	Write-Host "Downloading"
	Write-Host "from: $url"
	Write-Host "  to: $output"
	
	$c.DownloadFile($url, $output)
	
	Start-Process 'msiexec' @('/i', $output, '/passive', '/norestart') -Wait
	
	$env:Path += ';c:\Python27;c:\Python27\Scripts'
}

if (!(Test-Path "c:\Python27\Scripts\pip.exe")) {
	Write-Host "Installing easy_install, pip and virtualenv..."
	$c.DownloadFile('https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py', "$env:Temp\ez_setup.py")
	$c.DownloadFile('https://raw.github.com/pypa/pip/master/contrib/get-pip.py', "$env:Temp\get-pip.py")
	Start-Process 'C:\Python27\python.exe' @("$env:Temp\ez_setup.py") -Wait
	Start-Process 'C:\Python27\python.exe' @("$env:Temp\get-pip.py") -Wait
	Start-Process 'C:\Python27\Scripts\easy_install' @('install', 'virtualenv') -Wait
	Start-Process 'C:\Python27\Scripts\pip' @('install', 'git-up') -Wait
}
