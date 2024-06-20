function F15 {
  <#
 .SYNOPSIS
  This PowerShell module will open a new minimized window & run a script to press F15 key every minute to prevent sleep.

 .NOTES
  Script written by Brian Stark of BStarkIT 

  .DESCRIPTION
  written by BStark

 .LINK
  Scripts can be found at:
  https://github.com/BStarkIT

#>
    Start-Process "C:\Program Files\PowerShell\7\pwsh.exe" -WindowStyle Minimized -ArgumentList ("-ExecutionPolicy Bypass -noninteractive -noprofile "), "-command C:\PS\PSModules\F15\F15.ps1"
}
