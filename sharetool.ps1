<#
.SYNOPSIS
Simple map network drive script

.DESCRIPTION
This script will create a network share, a local user, then will map a Z drive connecting to the other pc's share folder.
this needs to run as admin to create the local account

.NOTES
Script written by: Brian Stark
Date: 06/01/2025
Modified by:
Date:
Version: 1

#>
#### the values here can be changed but REMEBER to change to the same for both sides.
$pass = "Change_me1"
$user = "Local"
$remote_pc = "pc2"
$path = "C:\Share\"
##########################################
#create local account
$password = ConvertTo-SecureString $pass -AsPlainText -Force
$lpc = $env:COMPUTERNAME
$luser = $user + $lpc
New-LocalUser -name $user -Password $password
#check path and create if needed.
if (Test-Path -Path $path) {
    Write-Output "$path exists."
}
else {
    Write-Output "$path does not currently exist."
    New-Item -ItemType Directory -Path $path
}
#add permissions to folder
$acl = Get-Acl -Path $path
$ace = New-Object System.Security.Accesscontrol.FileSystemAccessRule ("testuser", "Read", "Allow")
$acl.AddAccessRule($ace)
Set-Acl -Path $path -AclObject $acl
#share setup
$Parameters = @{
    Name       = 'Local Share'
    Path       = $path
    FullAccess = $luser,"everyone"
}
New-SmbShare @Parameters
# pause while share is made on 2nd pc
Write-Output "Local share created - please run to this point on $remote_pc"
Write-Output "Press return once other pc at this stage."
Pause
#map drive 
$remote = $Path
$remote.replace('C:',"\\$remote_pc")
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("z:", $remote, $true, ".\$user", $pass)
Write-Output "Remote share now set as Z drive. complete script on 2nd pc."
break
