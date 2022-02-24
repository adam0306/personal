#This script is intended to create and email a report of the  Virtual Infrastructure in CSV format file to the Server group for review.
#The report will contain the total number of snapshots in the environment, number of hosts, machines that need disks to be consolidated, count of VMs, CPU, Memory, and Storage Usage.
#Created by: Adam Chandler
#Date: July 2017
$Date=Get-Date
$Snapshots=(get-vm | Get-snapshot).count
$Consolidate=(Get-VM | where {$_.ExtensionData.Runtime.consolidationNeeded}).count
$HostCount=(Get-VMHost).count
$VMCount=(Get-VM).count
$MemoryUsed=(Get-VMHost | measure MemoryUsageGB -sum).sum
$MemoryUsedDivide=$MemoryUsed/1024
$MemoryTotal=(Get-VMHost | measure MemoryTotalGB -sum).sum
$MemoryTotalDivide=$MemoryTotal/1024
$CPUUsed=(Get-VMHost | measure CpuUsageMhz -sum).sum
$CPUUsedDivide=$CPUUsed/1024
$CPUTotal=(Get-VMHost | measure CpuTotalMhz -sum).sum
$CPUTotalDivide=$CPUTotal/1024
$StorageTotal=(Get-Datastore | measure CapacityGB -sum).sum
$StorageTotalDivide=$StorageTotal/1024
$FreeSpace=(Get-Datastore | measure FreeSpaceGB -sum).sum
$FreeSpaceDivide=$FreeSpace/1024
$UsedSpace=(Get-VM | measure UsedSpaceGB -sum).sum
$UsedSpaceDivide=$UsedSpace/1024
$Provisioned=(Get-VM | measure ProvisionedSpaceGB -sum).sum
$ProvisionedDivide=$Provisioned/1024
$StorageUsage=$Provisioned/$StorageTotal
$StoragePercentage=$UsedSpace/$StorageTotal
#$SMTP=
#$ServerEmail=
$Report=Write-Output "Today is $Date.`nThere are $Snapshots Snapshots across $VMCount VMs running on $HostCount VMHosts in the Environment."
$CPU=Write-Output "CPU: The $VMCount VMs are using a total of $CPUUsedDivide GHZ of CPU out of a maximum of $CPUTotalDivide GHZ."
$Memory=Write-Output "Memory: There is a total Memory Capacity of $MemoryTotalDivide TB with $MemoryUsedDivide TB of used."
$Storage=Write-Output "Storage: The $VMCount VMs are using $UsedSpaceDivide TB out of $StorageTotalDivide TB available across all networks. We have $ProvisionedDivide TB of provisioned data on our Storage. This equates to $StoragePercentage % of Provisioned storage and $storageUsage % of Used storage."
$Consolidation=Write-Output "There are $Consolidate VMs that need to have their disks Consolidated."
$Report,$CPU,$Memory,$Storage,$Consolidation | out-file -FilePath C:\Users\achandle\Storage\Reports.txt -Append -Width 200