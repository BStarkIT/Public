param
(
    [Parameter(Mandatory)]$User
)
$workinguser = Get-ADUser -Identity $User -Properties *
$oldSam = $workinguser.SamAccountName
$oldGiven = $workinguser.GivenName
$oldDisplay = $workinguser.DisplayName
$oldUserPrincipalName = $workinguser.UserPrincipalName
$oldSurname = $workinguser.Surname
$oldmail = $workinguser.mail
$oldUserPrincipalName = $workinguser.UserPrincipalName