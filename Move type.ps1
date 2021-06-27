$format = "avi"
$Path = F:\

get-ChildItem -recurse -ErrorAction "SilentlyContinue" -include $Extension | 
 Where-Object {$_.extension -eq "$format"}
 ForEach-Object {
        Write-Output "$($_.fullname) $format"
        Move-Item $_.fullname G:\Input\
    }