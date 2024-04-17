# We will begin by prompting the user for the desired safe name.
$SafeName = (Read-Host -Prompt 'Enter the Safe Name to continue.').ToUpper()
if ($SafeName) {
    Write-Host "We will now create the safe $SafeName ."
} else {
    Write-Warning -Message "The Safe Name must be entered."
}
# We will begin by prompting the user for the description of the new safe.
$Description = (Read-Host -Prompt 'Enter the description of the new Safe to continue.').ToUpper()
if ($Description) {
    Write-Host "We will now create the safe with the provided description $Description ."
} else {
    Write-Warning -Message "The description must be entered."
}
# We will now ensure that each of the necessary PowerShell modules used are installed.
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module psPAS
Install-Module CredentialRetriever
# Retrieving the Credential to be used to create the new safe via Central Credential Provider.
$result = Get-CCPCredential -AppID App -Safe Safe -Object ObjectName -URL https://pvwa
$result.ToCredential()
$credentials = $result.ToCredential()
# Using the retrieved credentials to create connection to CyberArk.
New-PASSession -Credential $credentials -BaseURI https://pvwa
# Creating a new safe.
Add-PASSafe -SafeName "$SafeName"  -Description $Description -ManagingCPM PasswordManager -NumberOfDaysRetention 7
# Adding the builtin Vault Admins group to the safe members with all permissions.
Add-PASSafeMember -SafeName "$SafeName"  -MemberName "Vault Admins" -SearchIn Vault -UseAccounts $true -RetrieveAccounts $true -ListAccounts $true -AddAccounts $true -UpdateAccountContent $true -UpdateAccountProperties $true -InitiateCPMAccountManagementOperations $true -SpecifyNextAccountContent $true -RenameAccounts $true -DeleteAccounts $true -UnlockAccounts $true -ManageSafe $true -ManageSafeMembers $true -BackupSafe $true -ViewAuditLog $true -ViewSafeMembers $true -AccessWithoutConfirmation $true -CreateFolders $true -DeleteFolders $true -MoveAccountsAndFolders $true
#//TODO: Define new user permissions.
# Adding the builtin Auditors group to the safe members.
Add-PASSafeMember -SafeName "$SafeName" -MemberName "" -SearchIn Vault -UseAccounts $true -RetrieveAccounts $true -ListAccounts $true -AddAccounts $true -UpdateAccountContent $true -UpdateAccountProperties $true -InitiateCPMAccountManagementOperations $true -SpecifyNextAccountContent $true -RenameAccounts $true -DeleteAccounts $true -UnlockAccounts $true -ViewAuditLog $true -ViewSafeMembers $true -AccessWithoutConfirmation $true -MoveAccountsAndFolders $true
# Adding the Safe user LDAP based group to the safe members.
Add-PASSafeMember -SafeName "$SafeName" -MemberName "" -SearchIn domain -UseAccounts $true -RetrieveAccounts $true -ListAccounts $true -AddAccounts $true -UpdateAccountContent $true -UpdateAccountProperties $true -InitiateCPMAccountManagementOperations $true -SpecifyNextAccountContent $true -RenameAccounts $true -DeleteAccounts $true -UnlockAccounts $true -ViewAuditLog $true -ViewSafeMembers $true -AccessWithoutConfirmation $true -MoveAccountsAndFolders $true
# Remove the user that created the safe from the Safe members.
#Remove-PASSafeMember -SafeName  -MemberName "retrieved user"
#//TODO: There is an issue with the 'Remove-PASSafeMember' when removing the user that created the safe. That user is a "Quota Owner" and cannot be removed using this action.

<#
Permissions Legend

-UseAccounts
-RetrieveAccounts
-ListAccounts
-AddAccounts
-UpdateAccountContent
-UpdateAccountProperties
-InitiateCPMAccountManagementOperations
-SpecifyNextAccountContent
-RenameAccounts
-DeleteAccounts
-UnlockAccounts
-ManageSafe
-ManageSafeMembers
-BackupSafe
-ViewAuditLog
-ViewSafeMembers
-RequestsAuthorizationLevel (0,1,2)
-AccessWithoutConfirmation
-CreateFolders
-DeleteFolders
-MoveAccountsAndFolders
#>
