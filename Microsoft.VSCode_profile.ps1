$Env:PATH = "D:\Storage;$Env:PATH"
Set-Alias -Name np -Value "C:\Program Files\Notepad++\notepad++.exe"
$Major = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Major
$Minor = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Minor
$Patch = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Patch
$PS = ($Major,$Minor,$Patch) -Join "."
Write-Host "PowerShell V$PS - StarkIT.link Build"
