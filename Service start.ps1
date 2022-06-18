$ServiceName = 'Spooler'
$arrService = Get-Service -Name $ServiceName
if ($arrService.Status -ne 'Running') {
    Start-Service $ServiceName
}