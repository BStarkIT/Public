$folder = "y:\TV\Channel Zero"
get-childItem $folder -recurse -include '*HDTV*' | rename-item -newname { $_.name -replace 'HDTV-720P','NEW' }
get-childItem $folder -recurse -include '*HDTV*' | rename-item -newname { $_.name -replace 'HDTV-1080P','NEW' }
get-childItem $folder -recurse -include '*SDTV*' | rename-item -newname { $_.name -replace 'SDTV','NEW' }