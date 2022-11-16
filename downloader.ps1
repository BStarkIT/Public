# Source URL
$url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/vscode-pull-request-github/0.54.0/vspackage"

# Destation file
$dest = "c:\PS\Update.file"

# Download the file
function Download {
    Invoke-WebRequest -Uri $url -OutFile $dest
    if ((Get-Item "c:\PS\Update.file").length -gt 1kb) {
        break
    }
    Else {
        Invoke-WebRequest -Uri $url -OutFile $dest
    }
Download
}
Download



