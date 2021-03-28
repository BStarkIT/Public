Write-Host "Copying Document files"
robocopy "$env:UserProfile\Documents" \\control\paperwork\Docs /E /MIR /XX /MT:10
Write-Host "Copying Picture files"
robocopy "$env:UserProfile\Pictures" \\control\paperwork\Pics /E /MIR /XX /MT:10
Write-Host "Copying Download files"
robocopy "$env:UserProfile\Downloads" \\control\paperwork\Downloads /E /MIR /XX /MT:10
Write-Host "Copying Script files"
robocopy "$env:UserProfile\Git" \\control\paperwork\Git /E /MIR /XX /MT:10
