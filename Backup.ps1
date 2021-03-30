Write-Host "Copying Document files"
robocopy "$env:UserProfile\Documents" \\control\paperwork\Docs /E /MIR /MT:20
Write-Host "Copying Picture files"
robocopy "$env:UserProfile\Pictures" \\control\paperwork\Pics /E /MIR /MT:20
Write-Host "Copying Download files"
robocopy "$env:UserProfile\Downloads" \\control\paperwork\Downloads /E /MIR /MT:20
Write-Host "Copying Script files"
robocopy "$env:UserProfile\Git" \\control\paperwork\Git /E /MIR /MT:20
