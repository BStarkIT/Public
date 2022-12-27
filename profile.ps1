  <#
 .SYNOPSIS
  Custom profile for Brian Stark of BStarkIT

 .NOTES
  Script written by Brian Stark of BStarkIT 

  .DESCRIPTION
  written by BStark

 .LINK
  Scripts can be found at:
  https://github.com/BStarkIT

#>
Clear-Host
$env:PSModulePath = $Env:PSModulePath+";C:\PS\PSModules\"
New-Alias -Name tray -value C:\PS\Public\Tray.ps1
Set-Alias -Name np -Value "C:\Program Files\Notepad++\notepad++.exe"
$Major = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Major
$Minor = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Minor
$Patch = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Patch
$PS = ($Major,$Minor,$Patch) -Join "."
$Env:PATH = "C:\PS;$Env:PATH"
$NTIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$NTPrincipal = new-object Security.Principal.WindowsPrincipal $NTIdentity
$IsAdmin = $NTPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$hostversion="v$($Host.Version.Major).$($Host.Version.Minor)"
$hostname = $host.Name
IF ($IsAdmin)
{
    if($hostname -eq "ConsoleHost")
    {
        $host.ui.RawUI.WindowTitle = "StarkIT.Link PowerShell $hostversion - Running as ROOT"
    } else {
        $host.ui.RawUI.WindowTitle = "StarkIT.Link PowerShell ISE $hostversion - Running as ROOT"
    }
}
Else
{
    if($hostname -eq "ConsoleHost")
    {
        $host.ui.RawUI.WindowTitle = "StarkIT.Link PowerShell $hostversion"
    
    } else { 
        $host.ui.RawUI.WindowTitle = "StarkIT.Link PowerShell ISE $hostversion"
    }
}
Write-Host "PowerShell V$PS - StarkIT.link Build"
IP