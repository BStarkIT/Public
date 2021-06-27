$User = "ming\tyrael"
$PWord = ConvertTo-SecureString -String "@Sigma159!!" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
Write-Host "Making User folders"
New-Item -Path "D:\" -Name "Users" -ItemType "directory"
New-Item -Path "D:\Users\" -Name "Music" -ItemType "directory"
New-Item -Path "D:\Users\" -Name "Pictures" -ItemType "directory"
New-Item -Path "D:\Users\" -Name "Videos" -ItemType "directory"
New-Item -Path "D:\" -Name "Git" -ItemType "directory"
New-Item -Path "D:\Users\" -Name "Documents" -ItemType "directory"
New-Item -Path "D:\Users\" -Name "Desktop" -ItemType "directory"
New-Item -Path "D:\Users\" -Name "Downloads" -ItemType "directory"
New-Item -Path "D:\Users\" -Name "OneDrive" -ItemType "directory"
New-Item -Path "D:\Users\" -Name "GDrive" -ItemType "directory"
New-Item -Path "D:\Users\" -Name "DropBox" -ItemType "directory"
New-Item -Path "D:\" -Name "Temp" -ItemType "directory"
Remove-Variable -Force HOME
Set-Variable HOME "D:\Git" 
Write-Host "moving User folders"
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v {0DDD015D-B06C-45D5-8C4C-F59713854639} /t REG_SZ /d D:\Users\Pictures /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v {35286A68-3C57-41A1-BBB1-0EAE73D76C95} /t REG_SZ /d D:\Users\Videos /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v {7D83EE9B-2244-4E70-B1F5-5393042AF1E4} /t REG_SZ /d D:\Users\Downloads /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v {374DE290-123F-4565-9164-39C4925E467B} /t REG_SZ /d D:\Users\Downloads /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v {A0C69A99-21C8-4671-8703-7934162FCF1D} /t REG_SZ /d D:\Users\Music /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v {F42EE2D3-909F-4907-8871-4C22FC0BF756} /t REG_SZ /d D:\Users\Documents /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Music" /t REG_SZ /d D:\Users\Music /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Pictures" /t REG_SZ /d D:\Users\Pictures /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Video" /t REG_SZ /d D:\Users\Videos /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal /t REG_SZ /d D:\Users\Documents /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop /t REG_SZ /d D:\Users\Desktop /f
New-Item -ItemType Junction -Path "$env:UserProfile\Documents" -Target D:\Users\Documents
New-Item -ItemType Junction -Path "$env:UserProfile\Pictures" -Target D:\Users\Pictures
New-Item -ItemType Junction -Path "$env:UserProfile\Downloads" -Target D:\Users\Downloads
New-Item -ItemType Junction -Path "$env:UserProfile\Git" -Target D:\Git
New-Item -ItemType Junction -Path "$env:UserProfile\Videos" -Target D:\Users\Videos
New-Item -ItemType Junction -Path "$env:UserProfile\Desktop" -Target D:\Users\Desktop
[Environment]::SetEnvironmentVariable("[TEMP]","[D:\Temp]","User")
[Environment]::SetEnvironmentVariable("[TMP]","[D:\Temp]","User")
[Environment]::SetEnvironmentVariable("[PSExecutionPolicyPreference]","[RemoteSigned]","User")
Write-Host "Mapping drives"
New-PSDrive -Name "S" -PSProvider "FileSystem" -Root "\\kaos\Shelf1" -Credential $Credential -Persist
New-PSDrive -Name "T" -PSProvider "FileSystem" -Root "\\kaos\Shelf2" -Credential $Credential -Persist
New-PSDrive -Name "U" -PSProvider "FileSystem" -Root "\\kaos\Shelf3" -Credential $Credential -Persist
New-PSDrive -Name "V" -PSProvider "FileSystem" -Root "\\kaos\Shelf4" -Credential $Credential -Persist
New-PSDrive -Name "X" -PSProvider "FileSystem" -Root "\\Control\Paperwork" -Credential $Credential -Persist
New-PSDrive -Name "Y" -PSProvider "FileSystem" -Root "\\Control\Collection" -Credential $Credential -Persist
New-PSDrive -Name "Z" -PSProvider "FileSystem" -Root "\\arr\Scrapes" -Credential $Credential -Persist
Write-Host "Copying Document files"
robocopy "$env:UserProfile\Documents" \\control\paperwork\Docs /E /Z
Write-Host "Copying Picture files"
robocopy "$env:UserProfile\Pictures" \\control\paperwork\Pics /E /Z
Write-Host "Copying Download files"
robocopy "$env:UserProfile\Downloads" \\control\paperwork\Downloads /E /Z
Write-Host "Copying Script files"
robocopy "$env:UserProfile\Git" \\control\paperwork\Git /E /Z
Write-Host "Updating Document files"
robocopy \\control\paperwork\Docs "$env:UserProfile\Documents" /E /Z
Write-Host "Updating Picture files"
robocopy \\control\paperwork\Pics "$env:UserProfile\Pictures" /E /Z
Write-Host "Updating Download files"
robocopy \\control\paperwork\Downloads "$env:UserProfile\Downloads" /E /Z
Write-Host "Updating Script files"
robocopy \\control\paperwork\Git "$env:UserProfile\Git" /E /Z