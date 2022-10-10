
New-Alias -Name tray -value D:\git\Public\Tray.ps1
New-Alias -Name F15 -value D:\git\Public\F15.ps1
Set-Alias -Name np -Value "C:\Program Files\Notepad++\notepad++.exe"
$Major = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Major
$Minor = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Minor
$Patch = ((Get-Variable PSVersionTable -ValueOnly).PSVersion).Patch
$PS = ($Major,$Minor,$Patch) -Join "."
$Env:PATH = "D:\Storage;$Env:PATH"
Write-Host "PowerShell V$PS - StarkIT.link Build"
function IP {
    $Wan = (New-Object System.Net.WebClient).DownloadString('https://api.ipify.org')
    $Lan = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {($_.IPAddress -Like '10.*') -or ($_.IPAddress -Like '192.*')} | Select-Object -ExpandProperty IPAddress
    Write-Output "Lan - $Lan"
    Write-Output "Wan - $WAN"
}
function Sync {
    Export
    $Date = Get-Date -Format "dddd MM/dd/yyyy"
    $path = "$env:USERPROFILE\Downloads"
    $Days = "14"
    Copy-Item $PROFILE -Destination "D:\Storage\Code\Configuration"
    Get-ChildItem -Path $path -File -Recurse -Force | Where-Object { ($_.LastWriteTime -lt (Get-Date).AddDays(-$Days)) } | Remove-Item -Force
    Robocopy "$env:UserProfile\Documents" W:\Docs /MT:32 /E /Z 
    Robocopy "$env:UserProfile\Pictures" W:\Photos /MT:32 /E /Z 
    Robocopy D:\Public W:\Git\Public /MT:32 /E /Z
    Robocopy D:\Storage W:\Git\Storage /MT:32 /E /Z
    Set-Location D:\Public
    Git add .
    git commit -a -m "Update $Date"
    Git push
    git pull
    Set-Location D:\Storage
    Git add .
    git commit -a -m "Update $Date"
    Git push
    git pull
    Clear-RecycleBin -Force
}
function export {
    $ExportedTime = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
    $EdgeRelease = "Edge"
    $JSON_File_Path = "$($env:localappdata)\Microsoft\$($EdgeRelease)\User Data\Default\Bookmarks"
    $HTML_File_Dir = "$($env:userprofile)\Documents\"
    $HTML_File_Path = "$($HTML_File_Dir)\EdgeChromium-Bookmarks.backup_$($ExportedTime).html"
    $Date_LDAP_NT_EPOCH = Get-Date -Year 1601 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0
    if (!(Test-Path -Path $JSON_File_Path -PathType Leaf)) {
        throw "Source-File Path $JSON_File_Path does not exist!" 
    }
    if (!(Test-Path -Path $HTML_File_Dir -PathType Container)) { 
        throw "Destination-Directory Path $HTML_File_Dir does not exist!" 
    }
    # ---- HTML Header ----
    $BookmarksHTML_Header = @'
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file.
     It will be read and overwritten.
     DO NOT EDIT! -->
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
'@
    $BookmarksHTML_Header | Out-File -FilePath $HTML_File_Path -Force -Encoding utf8
    # ---- Enumerate Bookmarks Folders ----
    Function Get-BookmarkFolder {
        [cmdletbinding()] 
        Param( 
            [Parameter(Position = 0, ValueFromPipeline = $True)]
            $Node 
        )
        function ConvertTo-UnixTimeStamp {
            param(
                [Parameter(Position = 0, ValueFromPipeline = $True)]
                $TimeStamp 
            )
            $date = [Decimal] $TimeStamp
            if ($date -gt 0) { 
                # Timestamp Conversion: JSON-File uses Timestamp-Format "Ticks-Offset since LDAP/NT-Epoch"
                $date = $Date_LDAP_NT_EPOCH.AddTicks($date * 10) # Convert the JSON-Timestamp to a valid PowerShell date
                # $DateAdded # Show Timestamp in Human-Readable-Format (Debugging-purposes only)																					
                $date = $date | Get-Date -UFormat %s # Convert to Unix-Timestamp
                $unixTimeStamp = [int][double]::Parse($date) - 1 # Cut off the Milliseconds
                return $unixTimeStamp
            }
        }   
        if ($node.name -like "Favorites Bar") {
            $DateAdded = [Decimal] $node.date_added | ConvertTo-UnixTimeStamp
            $DateModified = [Decimal] $node.date_modified | ConvertTo-UnixTimeStamp
            "        <DT><H3 FOLDED ADD_DATE=`"$($DateAdded)`" LAST_MODIFIED=`"$($DateModified)`" PERSONAL_TOOLBAR_FOLDER=`"true`">$($node.name )</H3>" | Out-File -FilePath $HTML_File_Path -Append -Force -Encoding utf8
            "        <DL><p>" | Out-File -FilePath $HTML_File_Path -Append -Force -Encoding utf8
        }
        foreach ($child in $node.children) {
            $DateAdded = [Decimal] $child.date_added | ConvertTo-UnixTimeStamp    
            $DateModified = [Decimal] $child.date_modified | ConvertTo-UnixTimeStamp
            if ($child.type -eq 'folder') {
                "        <DT><H3 ADD_DATE=`"$($DateAdded)`" LAST_MODIFIED=`"$($DateModified)`">$($child.name)</H3>" | Out-File -FilePath $HTML_File_Path -Append -Force -Encoding utf8
                "        <DL><p>" | Out-File -FilePath $HTML_File_Path -Append -Force -Encoding utf8
                Get-BookmarkFolder $child # Recursive call in case of Folders / SubFolders
                "        </DL><p>" | Out-File -FilePath $HTML_File_Path -Append -Force -Encoding utf8
            }
            else {
                "        <DT><A HREF=`"$($child.url)`" ADD_DATE=`"$($DateAdded)`">$($child.name)</A>" | Out-File -FilePath $HTML_File_Path -Append -Encoding utf8
            }
        }
        if ($node.name -like "Favorites Bar") {
            "        </DL><p>" | Out-File -FilePath $HTML_File_Path -Append -Force -Encoding utf8
        }
    }
    # ---- Convert the JSON Contens (recursive) ----
    $data = Get-content $JSON_File_Path -Encoding UTF8 | out-string | ConvertFrom-Json
    $sections = $data.roots.PSObject.Properties | Select-Object -ExpandProperty name
    ForEach ($entry in $sections) { 
        $data.roots.$entry | Get-BookmarkFolder
    }
    # ---- HTML Footer ----
    '</DL>' | Out-File -FilePath $HTML_File_Path -Append -Force -Encoding utf8
}
IP

