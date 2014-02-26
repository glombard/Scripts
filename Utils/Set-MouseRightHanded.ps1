# PowerShell script to swap mouse buttons.
# This one makes the left mouse button the
# primary button for right-handed mouse users.
 
$swapButtons = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
public static extern bool SwapMouseButton(bool swap);
'@ -Name "NativeMethods" -Namespace "PInvoke" -PassThru
 
# Use $true for left-handed mouse and $false for right-handed mouse.
[bool]$returnValue = $swapButtons::SwapMouseButton($false)
