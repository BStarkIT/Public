
<#
Disable User Accounts for Leavers
Version 5.01
13/07/2022
.SYNOPSIS
This PowerShell script is to process the accounts of Leavers.

.NOTES
helpdesk staff run a shorcut to Users - Disable Leaver Accounts.
13/07/2022  BS  5.0 Rebuild of script from scratch matching current requirements

This script performs the following on a User account.
AD account - Disables Users account.
AD account - Moves user account to Disabled_Leavers OU.
AD account - Labels account to be deleted in 90 Days.
Email - Hides email address from Global Address list.
Email - Stops mailbox from receiving email.
Email - Removes Users shared mailbox permissions.
Server - Labels user P drive folders to be deleted in 1 month.
Backup - Gets Users membership of Security Groups and Distribution lists and backs up on users p drive.
Groups - Removes User from all Security groups and Distribution lists.

.DESCRIPTION
written by BStark

.LINK
Scripts can be found at:
https://github.com/BStarkIT 
#>
$version = '5.01'
$message = "
AD account - Disables Users account.
AD account - Moves user account to Z-Disabled_Leavers OU.
AD account - Labels account to be deleted in 90 Days.
Email - Hides email address from Global Address list.
Email - Stops mailbox from receiving email.
Email - Removes Users shared mailbox permissions.
Server - Labels user P drive folders to be deleted in 1 month.
Backup - Gets Users membership of Security Groups and Distribution lists and backs up on users p drive.
Groups - Removes User from all Security groups and Distribution lists."
#
$Date = Get-Date -Format "dd-MM-yyyy"
Start-Transcript -Path "\\Server.local\Scripts\Logs\Disable\$Date.txt" -append
$Icon = '\\Server.local\Scripts\Resources\Icons\EditUser.ico'
#
#  Create Session with Exchange 2013   #
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://EXCHANGE-01.domain.local/powershell -Authentication Kerberos  
Import-PSSession $session
#
# Get listof UserNames from AD OU's   #
$UserNameList = Get-ADUser -filter * -searchbase 'OU=Users,DC=Domain,DC=local' -Properties DisplayName | Select-Object Displayname | Select-Object -ExpandProperty DisplayName
#  Show Start Message:   #
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
$StartMessage = [System.Windows.Forms.MessageBox]::Show("This script performs the following on a User account." + "`n" + "$message", 'Disable User Account for Leavers.',
    [System.Windows.Forms.MessageBoxButtons]::OKCancel, [System.Windows.Forms.MessageBoxIcon]::Information)
if ($StartMessage -eq 'Cancel') {
    Exit
} 
else {
    # create the pop up information form   #
    Function PopUpForm {
        Add-Type -AssemblyName System.Windows.Forms    
        # create form
        $RBACCatch = $null
        $PopForm = New-Object System.Windows.Forms.Form
        $PopForm.Text = "Disable User Account for Leavers v$version."
        $PopForm.Size = New-Object System.Drawing.Size(420, 200)
        $PopForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;
        # Add Label
        $PopUpLabel = New-Object System.Windows.Forms.Label
        $PopUpLabel.Location = '80, 40' 
        $PopUpLabel.Size = '300, 80'
        $PopUpLabel.Text = $poplabel
        $PopForm.Controls.Add($PopUpLabel)
        # Show the form
        $PopForm.Show() | Out-Null
        # wait 2 seconds
        Start-Sleep -Seconds 2
        # close form
        $PopForm.Close() | Out-Null
    }
    Function LeaverProcess {
        [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
        [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') 
        # Set the details of the form. #
        $LeaverProcessForm = New-Object System.Windows.Forms.Form
        $LeaverProcessForm.width = 745
        $LeaverProcessForm.height = 475
        $LeaverProcessForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;
        $LeaverProcessForm.Controlbox = $false
        $LeaverProcessForm.Icon = $Icon
        $LeaverProcessForm.FormBorderStyle = 'Fixed3D'
        $LeaverProcessForm.Text = "Disable User Account for Leavers v$version."
        $LeaverProcessForm.Font = New-Object System.Drawing.Font('Ariel', 10)
        $LeaverBox1 = New-Object System.Windows.Forms.GroupBox
        $LeaverBox1.Location = '40,20'
        $LeaverBox1.size = '650,80'
        $LeaverBox1.text = '1. Select a UserName from the list:'
        $LeavertextLabel1 = New-Object 'System.Windows.Forms.Label';
        $LeavertextLabel1.Location = '20,35'
        $LeavertextLabel1.size = '200,40'
        $LeavertextLabel1.Text = 'Username:' 
        $LeaverMBNameComboBox1 = New-Object System.Windows.Forms.ComboBox
        $LeaverMBNameComboBox1.Location = '275,30'
        $LeaverMBNameComboBox1.Size = '350, 350'
        $LeaverMBNameComboBox1.AutoCompleteMode = 'Suggest'
        $LeaverMBNameComboBox1.AutoCompleteSource = 'ListItems'
        $LeaverMBNameComboBox1.Sorted = $true;
        $LeaverMBNameComboBox1.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList;
        $LeaverMBNameComboBox1.DataSource = $UserNameList
        $LeaverMBNameComboBox1.Add_SelectedIndexChanged( { $LeaverSelectedMailBoxNametextLabel6.Text = "$($LeaverMBNameComboBox1.SelectedItem.ToString())" })
        $LeaverBox2 = New-Object System.Windows.Forms.GroupBox
        $LeaverBox2.Location = '40,120'
        $LeaverBox2.size = '650,215'
        $LeaverBox2.text = '2. Check the details below are correct before proceeding:'
        $LeavertextLabel3 = New-Object System.Windows.Forms.Label
        $LeavertextLabel3.Location = '20,40'
        $LeavertextLabel3.size = '100,40'
        $LeavertextLabel3.Text = 'The User:'
        $LeavertextLabel4 = New-Object System.Windows.Forms.Label
        $LeavertextLabel4.Location = '330,20'
        $LeavertextLabel4.Font = New-Object System.Drawing.Font('Ariel', 8)
        $LeavertextLabel4.size = '310,170'
        $LeavertextLabel4.Text = $message
        $LeavertextLabel5 = New-Object System.Windows.Forms.Label
        $LeavertextLabel5.Location = '20,150'
        $LeavertextLabel5.size = '330,40'
        $LeavertextLabel5.Text = 'Will have the following actioned on their account:'
        $LeaverSelectedMailBoxNametextLabel6 = New-Object System.Windows.Forms.Label
        $LeaverSelectedMailBoxNametextLabel6.Location = '20,80'
        $LeaverSelectedMailBoxNametextLabel6.Size = '350,40'
        $LeaverSelectedMailBoxNametextLabel6.ForeColor = 'Blue'
        $LeaverBox3 = New-Object System.Windows.Forms.GroupBox
        $LeaverBox3.Location = '40,345'
        $LeaverBox3.size = '650,30'
        $LeaverBox3.text = '3. Click Ok to Process User or Exit:'
        $LeaverBox3.button
        $OKButton = new-object System.Windows.Forms.Button
        $OKButton.Location = '590,385'
        $OKButton.Size = '100,40'          
        $OKButton.Text = 'Ok'
        $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $CancelButton = new-object System.Windows.Forms.Button
        $CancelButton.Location = '470,385'
        $CancelButton.Size = '100,40'
        $CancelButton.Text = 'Exit'
        $CancelButton.add_Click( {
                $LeaverProcessForm.Close()
                $LeaverProcessForm.Dispose()
                $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel })
        $LeaverProcessForm.Controls.AddRange(@($LeaverBox1, $LeaverBox2, $LeaverBox3, $OKButton, $CancelButton))
        $LeaverBox1.Controls.AddRange(@($LeavertextLabel1, $LeaverMBNameComboBox1))
        $LeaverBox2.Controls.AddRange(@($LeavertextLabel3, $LeavertextLabel4, $LeavertextLabel5, $LeaverSelectedMailBoxNametextLabel6))
        $LeaverProcessForm.Add_Shown( { $LeaverProcessForm.Activate() })    
        $dialogResult = $LeaverProcessForm.ShowDialog()
        $O365Email = $null
        # If the OK button is selected
        if ($dialogResult -eq 'OK') {
            #  CHECK - Don't accept no User selection   # 
            if ($LeaverSelectedMailBoxNametextLabel6.Text -eq '') {
                Write-Host " No user selected"
                [System.Windows.Forms.MessageBox]::Show("You need to select a User !!!!!`n`nTrying to enter blank fields is never a good idea.`n`nProcessing cannot continue.", 'Disable User Accounts for Leavers.',
                    [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                $LeaverProcessForm.Close()
                $LeaverProcessForm.Dispose()
                break
            }
            # CHECK -  User has email address   #
            $MailboxCheck = Get-ADUser -filter { DisplayName -eq $LeaverSelectedMailBoxNametextLabel6.Text } -Properties * | Select-Object EmailAddress | Select-Object -ExpandProperty EmailAddress
            If ($null -eq $MailboxCheck) {
                [System.Windows.Forms.MessageBox]::Show("The selected User does not have a mailbox`n`nProcessing cannot continue.", 'Disable User Accounts for Leavers.',
                    [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                $LeaverProcessForm.Close()
                $LeaverProcessForm.Dispose()
                Write-Host "No mailbox back to main form." 
                Return LeaverProcess 
            }
            #  get primary smtpaddress & sam name from mailbox display name  #
            $MailBoxPrimarySMTPAddress = $MailboxCheck
            $UserSamAccountName = Get-ADUser -filter { EmailAddress -eq $MailboxCheck } -Properties * | Select-Object SamAccountName | Select-Object -ExpandProperty SamAccountName 
            Write-Host "$UserSamAccountName selected for deletion."
            #
            # CHECK - continue if only 1 email address & sam is in pipe if not exit #
            if (($MailBoxPrimarySMTPAddress | Measure-Object).count -ne 1) { LeaverProcessForm }
            if (($UserSamAccountName | Measure-Object).count -ne 1) { LeaverProcessForm }
            #
            # set Date for 1 month ahead  #
            $DateDel = (Get-Date).AddDays(30).ToString('dd MMM yyyy') 
            Write-Host "deletion date $DateDel"
            #
            # get users membership of Security Groups and Distribution lists &  backup to P drive   #
            $poplabel = "Checking and backing up Users Security group`n`nand`n`nDistribution List membership."
            PopupForm
            $Usermembership = get-aduser -identity $UserSamAccountName -property MemberOf |
            Foreach-Object { $_.MemberOf | Get-AdGroup | Select-Object Name, SamaccountName | Select-object -ExpandProperty SamAccountName }
            $pdrive = test-path \\Server.local\home\P\$UserSamAccountName
            try {
                If (($null -ne $Usermembership) -and ($pdrive -eq $true)) {                   
                    $Usermembership | out-file \\Server.local\home\P\$UserSamAccountName\UserMembershipBackup.csv
                    Write-Host "Backed up Users Security group and Distribution List membership to $UserSamAccountName P drive." 
                }
            }
            catch {
                Write-Host "Error - Cant Users Security group and Distribution List membership to $UserSamAccountName P drive." 
                [System.Windows.Forms.MessageBox]::Show("Something has gone WRONG backing up the users group membership !!!.`n`nPlease contact the Systems Integration Team with the details.", 'Disable User Accounts for Leavers.',
                    [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                $LeaverProcessForm.Close()
                Return LeaverProcess  
            }
            #
            # change P drive folders name - add delete in 1 month to folder names  #
            $poplabel = "Renaming Users P drive folders`n`non Server`n`nwith Delete in 1 month."
            PopupForm
            try {
                if (test-path \\Server.local\Home\P\$UserSamAccountName) {
                    Get-Item \\Server.local\home\P\$UserSamAccountName | Rename-Item -NewName { $_.Name -replace "$", " xx DELETE after DATE - $Datedel" }
                    Write-Host "Renamed $UserSamAccountName P drive folder on Server" 
                }
            }
            catch {
                Write-Host "Error - Cannot Renamed $UserSamAccountName P drive folder on Server" 
                [System.Windows.Forms.MessageBox]::Show("Something has gone WRONG with renaming the users P drive !!!.`n`nPlease contact the Systems Integration Team with the details.", 'Processing User Accounts for Leavers.',
                    [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                $LeaverProcessForm.Close()
                Return LeaverProcess
            }
            #
            # Hide email address from Address list & accept only from helpdesk #
            $poplabel = "Hiding email address $MailBoxPrimarySMTPAddress from global address list`n`nand`n`nSetting users mailbox to not receive emails"
            PopupForm
            try {
                $email = get-mailbox $MailBoxPrimarySMTPAddress | Select-Object PrimarySmtpAddress | Select-Object -ExpandProperty PrimarySMTPAddress
                if ($null -eq $email) {
                    $O365Email = get-remotemailbox $MailBoxPrimarySMTPAddress | Select-Object PrimarySmtpAddress | Select-Object -ExpandProperty PrimarySMTPAddress
                    set-remotemailbox -identity $O365Email -AcceptMessagesOnlyFrom 'helpdesk' -HiddenFromAddressListsEnabled $true
                }
                else {
                    Get-Mailbox $MailBoxPrimarySMTPAddress | Set-Mailbox -AcceptMessagesOnlyFrom 'helpdesk' -HiddenFromAddressListsEnabled $true
                }
                Write-Host "Setting $MailBoxPrimarySMTPAddress mailbox not to receive emails and hiding from address list" 
            }
            catch {
                Write-Host "Error - Cannot set $MailBoxPrimarySMTPAddress mailbox not to receive emails" 
                [System.Windows.Forms.MessageBox]::Show("Something has gone WRONG setting the users mailbox !!!.`n`nPlease contact the Systems Integration Team with the details.", 'Processing User Accounts for Leavers.',
                    [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                $LeaverProcessForm.Close()
                Return LeaverProcess  
            }
            #
            # disable user AD account   #
            $poplabel = "Disabling Users account."
            PopupForm
            try {
                Disable-ADAccount -Identity $UserSamAccountName
                Write-Host "Disabling AD Account $UserSamAccountName" 
            }
            catch {
                Write-Host "Error - Cannot disable AD Account $UserSamAccountName"
                [System.Windows.Forms.MessageBox]::Show("Something has gone WRONG disabling the users AD account !!!.`n`nPlease contact the Systems Integration Team with the details.", 'Processing User Accounts for Leavers.',
                    [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                $LeaverProcessForm.Close()
                Return LeaverProcess 
            }
            #
            # edit AD description field to delete account in 1 month & clear P drive paths   #
            $poplabel = "Editing users AD account:`n`nLabelling to be deleted in 1 month.`n`nClearing P drive path."
            PopupForm
            try {
                Get-ADUser $UserSamAccountName -Properties Description | ForEach-Object { Set-ADUser $_ -Description "$($_.Description) xx DELETE after DATE -- $Datedel" }
                Write-Host " Labelling $UserSamAccountName AD account to be deleted in 1 month and clearing P drive paths" 
            }
            catch {
                Write-Host "Error when Labelling $UserSamAccountName AD account to be deleted in 1 month and clearing P drive paths"
                [System.Windows.Forms.MessageBox]::Show("Something has gone WRONG labelling the users AD account to be deleted in 1 month !!!.`n`nPlease contact the Systems Integration Team with the details.", 'Disable User Accounts for Leavers.',
                    [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                $LeaverProcessForm.Close()
                Return LeaverProcess
            }
            #
            # move ad account to Z-Disabled Leavers ou   #
            $poplabel = "Moving user account to the `n`nDisabled_Leavers OU."
            PopupForm
            try {
                Get-ADUser $UserSamAccountName | Move-ADObject -targetpath 'OU=Disabled_Leavers,DC=Domain,DC=local'
                Write-Host "moving $UserSamAccountName AD account to Disabled_Leavers OU" 
            }
            catch {
                Write-Host "Error moving $UserSamAccountName AD account to Disabled_Leavers OU" 
                [System.Windows.Forms.MessageBox]::Show("Something has gone WRONG moving the users account to the Disabled_Leavers OU !!!.`n`nPlease contact the Systems Integration Team with the details.", 'Disable User Accounts for Leavers.',
                    [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                $LeaverProcessForm.Close()
                Return LeaverProcess 
            }
            #
            # get user shared mailbox access   #
            $poplabel = "Checking and removing`n`nany Users Shared Mailbox permissions"
            PopupForm
            $SharedMailboxes = Get-ADUser -Identity $UserSamAccountName -Properties msExchDelegateListBL | Select-Object -ExpandProperty msExchDelegateListBL
            $SharedMailboxes -replace '^CN=|,.*$'
            foreach ($SharedMailbox in $SharedMailboxes) {
                $Shared = get-mailbox -identity $SharedMailbox | select-object PrimarySMTPAddress | Select-Object -ExpandProperty PrimarySMTPAddress
                if ($null = $Shared) {
                    $O365Shared = get-mailbox -identity $SharedMailbox | select-object PrimarySMTPAddress | Select-Object -ExpandProperty PrimarySMTPAddress
                    # temp command until O365 connector can be used
                }
                else {
                    $O365Shared = $null
                    Remove-MailboxPermission $Shared -User $UserSamAccountName -AccessRights FullAccess -confirm:$false 
                    Set-Mailbox $Shared -GrantSendOnBehalfTo @{remove = "$UserSamAccountName" }
                    Write-Host "Removed $UserSamAccountName Shared Mailbox permissions" 
                }
            }
            #
            # Remove User from Security groups and Distribution lists   #
            $poplabel = "Checking and removing User from`n`nSecurity groups`n`nand Distribution Lists."
            PopupForm
            try {
                If ($null -ne $Usermembership) {                    
                    $Usermembership | ForEach-Object {
                        Remove-ADGroupMember -Identity $_ -Member $UserSamAccountName -confirm:$false
                        Write-Host "Removed $UserSamAccountName from groups" }
                }
            }
            catch {
                Write-Host "Error Removing $UserSamAccountName from groups"
                [System.Windows.Forms.MessageBox]::Show("Something has gone WRONG removing the users from the groups !!!.`n`nPlease contact the Systems Integration Team with the details.", 'Disable User Accounts for Leavers.',
                    [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                $LeaverProcessForm.Close()
                Return LeaverProcess
            }
            $RBACUser = "$UserSamAccountName" + "_a"
            try {
                $RBACCatch = Get-ADUser -Identity $RBACUser -Properties * | Select-Object SamAccountName | Select-Object -ExpandProperty SamAccountName
                Get-ADUser $RBACCatch -Properties Description | ForEach-Object { Set-ADUser $_ -Description "$($_.Description) xx DELETE after DATE - $Datedel" }
                Get-ADUser $RBACCatch | Move-ADObject -targetpath 'OU=Disabled_Leavers,DC=Domain,DC=local'
                Write-Host "moving $RBACCatch AD account to Disabled_Leavers OU" 
            }
            catch {
                Write-Output "no RBAC account"
            }
            
            Write-Host "Complete"
            [System.Windows.Forms.MessageBox]::Show("Disable User Accounts for Leavers for $($LeaverMBNameComboBox1.SelectedItem.ToString()) - Completed.`n`nPlease remove user from SafeNet Portal.", 'Disable User Accounts for Leavers.',
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $LeaverProcessForm.Close()
            Return LeaverProcess
            # Leaver processing completed   #
        } 
    }  
    LeaverProcess 
}

