# PowerShell script to swap mouse buttons for left-handed mouse users.
# (Make right mouse button the primary button...)
 
$swapButtons = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
public static extern bool SwapMouseButton(bool swap);
'@ -Name "NativeMethods" -Namespace "PInvoke" -PassThru
 
# Use $true for left-handed mouse and $false for right-handed mouse.
[bool]$returnValue = $swapButtons::SwapMouseButton($true)
