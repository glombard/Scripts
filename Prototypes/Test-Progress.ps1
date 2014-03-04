# Example usage:

$env:PSModulePath += ';' + $PSScriptRoot
$progress = Import-Module Progress.psm1 -AsCustomObject

$progress.Init("Getting the file you need")
$downloading = $progress.Step("Downloading")
$extracting = $progress.Step("Extracting")

# Now set each step along the way:
$downloading.Set()
[System.Threading.Thread]::Sleep(1000)
$extracting.Set()
[System.Threading.Thread]::Sleep(1000)
$progress.Done()
[System.Threading.Thread]::Sleep(1000)
