if (Test-Path HKCU:\Software\Microsoft\VSWinExpress)
{
    $vs = "VSWinExpress"
}
elseif (Test-Path HKCU:\Software\Microsoft\VWDExpress)
{
    $vs = "VWDExpress"
}
else
{
    $vs = "VisualStudio"
}

Write-Host "Fixing menu caps for $vs ..."

if (!(Test-Path HKCU:\Software\Microsoft\$vs\11.0\General))
{
    New-Item -Path HKCU:\Software\Microsoft\$vs\11.0\General -Force
}

Set-ItemProperty -Path HKCU:\Software\Microsoft\$vs\11.0\General -Name SuppressUppercaseConversion -Type DWord -Value 1
