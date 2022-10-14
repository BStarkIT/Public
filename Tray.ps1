# Load Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$MyIcon = [Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)

# Create Primary form
$objForm = New-Object System.Windows.Forms.Form
$objForm.Visible = $false
$objForm.WindowState = "minimized"
$objForm.ShowInTaskbar = $false
$objForm.add_Closing({ $objForm.ShowInTaskBar = $False })
#
$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon
$objNotifyIcon.Icon = $MyIcon
$objNotifyIcon.Text = "TrayUtility"
$objNotifyIcon.Visible = $true
#
$objContextMenu = New-Object System.Windows.Forms.ContextMenu
#
# Build the context menu
# Create Menu Item
$ToggleMenuItem1 = New-Object System.Windows.Forms.MenuItem
$ToggleMenuItem1.Index = 1
$ToggleMenuItem1.Text = "RDP"
$ToggleMenuItem1.add_Click({
    Invoke-Expression -Command "C:\Windows\System32\mstsc.exe"
})
$ToggleMenuItem2 = New-Object System.Windows.Forms.MenuItem
$ToggleMenuItem2.Index = 2
$ToggleMenuItem2.Text = "CommVault"
$ToggleMenuItem2.add_Click({
    Start-Process "C:\PS\galaxy.jnlp"
})
$ToggleMenuItem3 = New-Object System.Windows.Forms.MenuItem
$ToggleMenuItem3.Index = 3
$ToggleMenuItem3.Text = "MMC"
$ToggleMenuItem3.add_Click({
    Start-Process MMC.exe -Verb runAs
})
$ToggleMenuItem4 = New-Object System.Windows.Forms.MenuItem
$ToggleMenuItem4.Index = 4
$ToggleMenuItem4.Text = "Palo Alto"
$ToggleMenuItem4.add_Click({
    Start-Process "cmd.exe"  "/c C:\PS\Devops\loop.bat"
})
$ToggleMenuItem5 = New-Object System.Windows.Forms.MenuItem
$ToggleMenuItem5.Index = 5
$ToggleMenuItem5.Text = "Remote"
$ToggleMenuItem5.add_Click({
    Start-Process "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\i386\CmRcViewer.exe" -Verb runAs
})
$ToggleMenuItem6 = New-Object System.Windows.Forms.MenuItem
$ToggleMenuItem6.Index = 6
$ToggleMenuItem6.Text = "AD"
$ToggleMenuItem6.add_Click({
    Start-Process dsa.msc -Verb runAs
})
$ToggleMenuItem7 = New-Object System.Windows.Forms.MenuItem
$ToggleMenuItem7.Index = 7
$ToggleMenuItem7.Text = "ISE"
$ToggleMenuItem7.add_Click({
    Start-Process "C:\Windows\system32\WindowsPowerShell\v1.0\PowerShell_ISE.exe"
})
$ToggleMenuItem8 = New-Object System.Windows.Forms.MenuItem
$ToggleMenuItem8.Index = 8
$ToggleMenuItem8.Text = "mRemote"
$ToggleMenuItem8.add_Click({
    Start-Process "C:\Program Files (x86)\mRemoteNG\mRemoteNG.exe"
})
$ToggleMenuItem8 = New-Object System.Windows.Forms.MenuItem
$ToggleMenuItem8.Index = 9
$ToggleMenuItem8.Text = "SCCM"
$ToggleMenuItem8.add_Click({
    Start-Process "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\Microsoft.ConfigurationManagement.exe" -Verb runAs
})
# Create an Exit Menu Item
$ExitMenuItem = New-Object System.Windows.Forms.MenuItem
$ExitMenuItem.Index = 10
$ExitMenuItem.Text = "E&xit"
$ExitMenuItem.add_Click({
    $objForm.Close()
    $objNotifyIcon.visible = $false
})
# Add the Menu Items to the Context Menu
$objContextMenu.MenuItems.Add($ToggleMenuItem1) | Out-Null
$objContextMenu.MenuItems.Add($ToggleMenuItem2) | Out-Null
$objContextMenu.MenuItems.Add($ToggleMenuItem3) | Out-Null
$objContextMenu.MenuItems.Add($ToggleMenuItem4) | Out-Null
$objContextMenu.MenuItems.Add($ToggleMenuItem5) | Out-Null
$objContextMenu.MenuItems.Add($ToggleMenuItem6) | Out-Null
$objContextMenu.MenuItems.Add($ToggleMenuItem7) | Out-Null
$objContextMenu.MenuItems.Add($ToggleMenuItem8) | Out-Null
$objContextMenu.MenuItems.Add($ToggleMenuItem9) | Out-Null
$objContextMenu.MenuItems.Add($ExitMenuItem) | Out-Null
#
# Assign the Context Menu
$objNotifyIcon.ContextMenu = $objContextMenu
$objForm.ContextMenu = $objContextMenu

# Show the Form - Keep it open
$objForm.ShowDialog() | Out-Null
$objForm.Dispose()
