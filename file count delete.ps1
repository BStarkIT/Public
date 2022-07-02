$path = "C:\Folder"
$count = Get-ChildItem $path -Recurse -File | Measure-Object | ForEach-Object{$_.Count}
Write-Output $count
if ($count -gt 100) {
    Get-ChildItem $path | Sort CreationTime | Select -First 1 | Remove-Item -Force -Recurse
}