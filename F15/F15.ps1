  <#
 .SYNOPSIS
  This PowerShell script will press the F15 key every minute to prevent sleep.

 .NOTES
  Script written by Brian Stark of BStarkIT 

  .DESCRIPTION
  written by BStark

 .LINK
  Scripts can be found at:
  https://github.com/BStarkIT

#>
  $wsh = New-Object -ComObject WScript.Shell 
  while (1) { 
    $wsh.SendKeys('+{F15}')
    Start-Sleep -seconds 59
  }