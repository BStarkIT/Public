$ServiceName = 'Papercut'
$arrService = Get-Service -Name $ServiceName
while ($arrService.Status -ne 'Running')
{
    Start-Service $ServiceName
    write-host $arrService.status
    write-host 'Service starting'
    Start-Sleep -seconds 3600
    $arrService.Refresh()
    if ($arrService.Status -eq 'Running')
    {
        Write-Host 'Service is now Running'
    }

}