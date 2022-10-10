$env:PSModulePath = $Env:PSModulePath+";D:\git\Modules\"
New-Alias -Name tray -value D:\git\Public\Tray.ps1
New-Alias -Name F15 -value D:\git\Public\F15.ps1
Set-Alias -Name np -Value "C:\Program Files\Notepad++\notepad++.exe"
$Major = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Major
$Minor = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Minor
$Patch = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Patch
$PS = ($Major,$Minor,$Patch) -Join "."
$Env:PATH = "D:\git\Storage;$Env:PATH"
Write-Host "PowerShell V$PS - StarkIT.link Build"
IP
