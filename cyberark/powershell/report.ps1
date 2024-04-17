# Retrieve the credentials using the AAM CCP that will be used to authenticate to CyberArk.
$result = Get-CCPCredential -AppID Application -Safe SafeName -Object ObjectName -URL https://pvwa
$result.ToCredential()
$credentials = $result.ToCredential()
# Create a connection to the Production CyberArk Environment using the retreived credentials.
New-PASSession -Credential $credentials -BaseURI https://pvwa
# Determine the Current Active Vault and EPV Version.
$Vault = Get-PASComponentSummary | where {$_.ComponentID -like "EPV"} | where {$_.Role -like "Primary"} | select -ExpandProperty IP
$ActiveVault = Resolve-DnsName -Name $Vault | select -ExpandProperty NameHost
$EPVVersion = Get-PASServer | select -ExpandProperty ExternalVersion
# Counting the number of connected CPM components.
$CPM = (Get-PASComponentDetail -ComponentID CPM | select -ExpandProperty ComponentUserName).count
# Counting the number of connected PVWA components.
$PVWA = (Get-PASComponentDetail -ComponentID PVWA | select -ExpandProperty ComponentUserName).count
# Counting the number of connected PSM components.
$PSM = (Get-PASComponentDetail -ComponentID SessionManagement | where {$_.ComponentUserName -like "PSMApp*"}).count
# Counting the number of connected PSMP components.
$PSMP = (Get-PASComponentDetail -ComponentID SessionManagement | where {$_.ComponentUserName -like "PSMPApp*"}).count
# Counting the number of connected AAM Agent components.
$ConnectedAAM = (Get-PASComponentDetail -ComponentID AIM | where {$_.IsLoggedOn -eq "True"} | select -ExpandProperty ComponentUserName).count
# Counting the number of disconnected AAM Agent components.
$DisconnectedAAM = (Get-PASComponentDetail -ComponentID AIM | where {$_.IsLoggedOn -ne "True"} | select -ExpandProperty ComponentUserName).count
# Counting the number of Applications.
$Applications = (Get-PASApplication).count
# Counting number of Managed Accounts
$ManagedAccounts = Get-PASComponentSummary | Where {$_.ComponentID -like "CPM"} | select -ExpandProperty ComponentSpecificStat
# Counting number of Concurrent PSM Sessions.
$Concurrent = Get-PASComponentSummary | Where {$_.ComponentID -like "SessionManagement"} | select -ExpandProperty ComponentSpecificStat
# Coming Version 11.7.
$EPVUsers = (Get-PASUser -ComponentUser "EPVUser").count
# (Get-PASAccount -safeName "SafeName" | where {$_.SecretManagement.Status -like "success"}).count
# (Get-PASAccount -safeName "SafeName" | where {$_.SecretManagement.Status -notlike "success"}).count
# [math]::Round($1st / $2nd * 100,4)

# Time to Write the results of the Report.
# what vault is primary and at what version?
# count the number of components
#   cpm
#   pvwa
#   psm
#   psmp
#   agents
#   applications
# count the number of epvusers
# managed accounts
# concurrent psm users
# accounts
# accounts
# accounts
# accounts


Write-host -BackgroundColor Black -ForegroundColor White -Object "The Active Vault is $ActiveVault running at version $EPVVersion.
`n
Below is a count of the number of components supporting the environment.
- CPM - $CPM
- PVWA - $PVWA
- PSM - $PSM
- PSMP - $PSMP
- Agents - Disconnected $DisconnectedAAM - Connected - $ConnectedAAM
- Applications - $Applications
- EPVUsers - $EPVUsers
- Managed Accounts - $ManagedAccounts
- Concurrent PSM Sessions - $Concurrent
"
# Write-host -BackgroundColor Black -ForegroundColor White -Object "The Active Vault is $math%."
