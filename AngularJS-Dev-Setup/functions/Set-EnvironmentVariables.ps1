function Set-Env {
	param ([string]$name, [string]$value)
	[Environment]::SetEnvironmentVariable($name, $value, "Machine")
}

function Set-EnvironmentVariables {
	Set-Env "CHROME_BIN" "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
	Set-Env "CHROME_CANARY_BIN" "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
	Set-Env "FIREFOX_BIN" "$env:ProgramFiles\Firefox\firefox.exe"
	Set-Env "IE_BIN" "$env:ProgramFiles\Internet Explorer\iexplorer.exe"
	Set-Env "PHANTOMJS_BIN" "C:\PhantomJS\phantomjs.exe"
}
