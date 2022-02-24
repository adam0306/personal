#This script is intended to create and email a report of the Linc Virtual Infrastructure in CSV format file to the Server group for review.
#The report will contain the total number of snapshots in the environment, number of hosts, machines that need disks to be consolidated, count of VMs, CPU, Memory, and Storage Usage.
#Created by: Adam Chandler
#Date: July 2017
Connect-VIServer -Server bhmvcenter01.company.com,atlvcenter01.company.com
$Date=Get-Date
$Snapshots=(get-vm | Get-snapshot).count
$Consolidate=(Get-VM | where {$_.ExtensionData.Runtime.consolidationNeeded}).count
$HostCount=(Get-VMHost).count
$VMCount=(Get-VM).count
$MemoryUsed=(Get-VMHost | measure MemoryUsageGB -sum).sum /1024
$MemoryUsedMATH=[System.Math]::Round($MemoryUsed,2)
$MemoryTotal=(Get-VMHost | measure MemoryTotalGB -sum).sum /1024
$MemoryTotalMATH=[System.Math]::Round($MemoryTotal,2)
$CPUUsed=(Get-VMHost | measure CpuUsageMhz -sum).sum /1024
$CPUUsedMATH=[System.Math]::Round($CPUUsed,2)
$CPUTotal=(Get-VMHost | measure CpuTotalMhz -sum).sum /1024
$CPUTotalMATH=[System.Math]::Round($CPUTotal,2)
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

$BHMSPACEUSED=(Get-Datacenter -Name Birmingham | Get-VM | measure UsedSpaceGB -sum).sum /1024
$BHMSPACEUSEDMATH=[System.Math]::Round($BHMSPACEUSED,2)
$BHMSPACETOTAL=(Get-Datacenter -Name Birmingham | Get-Cluster -Name 'Subscriber Facing' | Get-Datastore | measure CapacityGB -sum).sum /1024
$BHMSPACETOTALMATH=[System.Math]::Round($BHMSPACETOTAL,2)
$BHMSPACEPROV=(Get-Datacenter -Name Birmingham | Get-VM | Get-harddisk | measure CapacityGB -sum).sum /1024
$BHMSPACEPROVMATH=[System.Math]::Round($BHMSPACEPROV,2)
$BHMSPACEFREE=(Get-Datacenter -Name Birmingham | Get-Cluster -Name 'Subscriber Facing' | Get-Datastore | measure FreeSpaceGB -sum).sum /1024
$BHMSPACEFREEMATH=[System.Math]::Round($BHMSPACEFREE,2)

$ATLSPACEUSED=(Get-Datacenter -Name Atlanta | Get-VM | measure UsedSpaceGB -sum).sum /1024
$ATLSPACEUSEDMATH=[System.Math]::Round($ATLSPACEUSED,2)
$ATLSPACETOTAL=(Get-Datacenter -Name Atlanta | Get-Datastore | measure CapacityGB -sum).sum /1024
$ATLSPACETOTALMATH=[System.Math]::Round($ATLSPACETOTAL,2)
$ATLSPACEPROV=(Get-Datacenter -Name Atlanta | Get-VM | Get-harddisk | measure CapacityGB -sum).sum /1024
$ATLSPACEPROVMATH=[System.Math]::Round($ATLSPACEPROV,2)
$ATLSPACEFREE=(Get-Datacenter -Name Atlanta | Get-Datastore | measure FreeSpaceGB -sum).sum /1024
$ATLSPACEFREEMATH=[System.Math]::Round($ATLSPACEFREE,2)

$ATLPRODCPUTOTAL=(Get-Datacenter -Name Atlanta | Get-Cluster -Name Production | Get-VMHost | measure CpuTotalMhz -sum).sum /1024
$ATLPRODCPUTOTALMATH=[System.Math]::Round($ATLPRODCPUTOTAL,2)
$ATLPRODCPUUSED=(Get-Datacenter -Name Atlanta | Get-Cluster -Name Production | Get-VMHost | measure CpuUsageMhz -sum).sum /1024
$ATLPRODCPUUSEDMATH=[System.Math]::Round($ATLPRODCPUUSED,2)
$ATLPRODMEMTOTAL=(Get-Datacenter -Name Atlanta | Get-Cluster -Name Production | Get-VMHost | measure MemoryTotalGB -sum).sum /1024
$ATLPRODMEMTOTALMATH=[System.Math]::Round($ATLPRODMEMTOTAL,2)
$ATLPRODMEMUSED=(Get-Datacenter -Name Atlanta | Get-Cluster -Name Production | Get-VMHost | measure MemoryUsageGB -sum).sum /1024
$ATLPRODMEMUSEDMATH=[System.Math]::Round($ATLPRODMEMUSED,2)
$ATLPRODVMCount=(Get-Datacenter -Name Atlanta | Get-Cluster -Name Production | Get-VM).count
$ATLPRODHostCount=(Get-Datacenter -Name Atlanta | Get-Cluster -Name Production | Get-VMHost).count

$ATLSFCPUTOTAL=(Get-Datacenter -Name Atlanta | Get-Cluster -Name 'Subscriber Facing' | Get-VMHost | measure CpuTotalMhz -sum).sum /1024
$ATLSFCPUTOTALMATH=[System.Math]::Round($ATLSFCPUTOTAL,2)
$ATLSFCPUUSED=(Get-Datacenter -Name Atlanta | Get-Cluster -Name 'Subscriber Facing' | Get-VMHost | measure CpuUsageMhz -sum).sum /1024
$ATLSFCPUUSEDMATH=[System.Math]::Round($ATLSFCPUUSED,2)
$ATLSFMEMTOTAL=(Get-Datacenter -Name Atlanta | Get-Cluster -Name 'Subscriber Facing' | Get-VMHost | measure MemoryTotalGB -sum).sum /1024
$ATLSFMEMTOTALMATH=[System.Math]::Round($ATLSFMEMTOTAL,2)
$ATLSFMEMUSED=(Get-Datacenter -Name Atlanta | Get-Cluster -Name 'Subscriber Facing' | Get-VMHost | measure MemoryUsageGB -sum).sum /1024
$ATLSFMEMUSEDMATH=[System.Math]::Round($ATLSFMEMUSED,2)
$ATLSFVMCount=(Get-Datacenter -Name Atlanta | Get-Cluster -Name 'Subscriber Facing' | Get-VM).count
$ATLSFHostCount=(Get-Datacenter -Name Atlanta | Get-Cluster -Name 'Subscriber Facing' | Get-VMHost).count

$BHMPRODCPUTOTAL=(Get-Datacenter -Name Birmingham | Get-Cluster -Name Production | Get-VMHost | measure CpuTotalMhz -sum).sum /1024
$BHMPRODCPUTOTALMATH=[System.Math]::Round($BHMPRODCPUTOTAL,2)
$BHMPRODCPUUSED=(Get-Datacenter -Name Birmingham | Get-Cluster -Name Production | Get-VMHost | measure CpuUsageMhz -sum).sum /1024
$BHMPRODCPUUSEDMATH=[System.Math]::Round($BHMPRODCPUUSED,2)
$BHMPRODMEMTOTAL=(Get-Datacenter -Name Birmingham | Get-Cluster -Name Production | Get-VMHost | measure MemoryTotalGB -sum).sum /1024
$BHMPRODMEMTOTALMATH=[System.Math]::Round($BHMPRODMEMTOTAL,2)
$BHMPRODMEMUSED=(Get-Datacenter -Name Birmingham | Get-Cluster -Name Production | Get-VMHost | measure MemoryUsageGB -sum).sum /1024
$BHMPRODMEMUSEDMATH=[System.Math]::Round($BHMPRODMEMUSED,2)
$BHMPRODVMCount=(Get-Datacenter -Name Birmingham | Get-Cluster -Name Production | Get-VM).count
$BHMPRODHostCount=(Get-Datacenter -Name Birmingham | Get-Cluster -Name Production | Get-VMHost).count

$BHMSFCPUTOTAL=(Get-Datacenter -Name Birmingham | Get-Cluster -Name 'Subscriber Facing' | Get-VMHost | measure CpuTotalMhz -sum).sum /1024
$BHMSFCPUTOTALMATH=[System.Math]::Round($BHMSFCPUTOTAL,2)
$BHMSFCPUUSED=(Get-Datacenter -Name Birmingham | Get-Cluster -Name 'Subscriber Facing' | Get-VMHost | measure CpuUsageMhz -sum).sum /1024
$BHMSFCPUUSEDMATH=[System.Math]::Round($BHMSFCPUUSED,2)
$BHMSFMEMTOTAL=(Get-Datacenter -Name Birmingham | Get-Cluster -Name 'Subscriber Facing' | Get-VMHost | measure MemoryTotalGB -sum).sum /1024
$BHMSFMEMTOTALMATH=[System.Math]::Round($BHMSFMEMTOTAL,2)
$BHMSFMEMUSED=(Get-Datacenter -Name Birmingham | Get-Cluster -Name 'Subscriber Facing' | Get-VMHost | measure MemoryUsageGB -sum).sum /1024
$BHMSFMEMUSEDMATH=[System.Math]::Round($BHMSFMEMUSED,2)
$BHMSFVMCount=(Get-Datacenter -Name Birmingham | Get-Cluster -Name 'Subscriber Facing' | Get-VM).count
$BHMSFHostCount=(Get-Datacenter -Name Birmingham | Get-Cluster -Name 'Subscriber Facing' | Get-VMHost).count

$Overall=Write-Output "Today is $Date.`n`nSummary`nThere are $Snapshots Snapshots remaining across $VMCount VMs running on $HostCount VMHosts in the company Environment.`nThere is a total CPU capacity in the environment of $CPUTotalMATH GHZ and $CPUUsedMATH GHZ of used CPU.`nThere is a total Memory Capacity of $MemoryTotalMATH TB with $MemoryUsedMATH TB of used Memory.`nThere are $Consolidate VMs that need to have their disks Consolidated.`n`n`n"
$BHMStorage=Write-Output "The Storage for the Birmingham Virtual Infrastructure has a Total Capacity of $BHMSPACETOTALMATH TB with $BHMSPACEPROVMATH TB Provisioned and $BHMSPACEUSEDMATH TB Used.`nThis leaves $BHMSPACEFREEMATH TB of Free Space.`n`n"
$ATLStorage=Write-Output "The Storage for the Atlanta Virtual Infrastructure has a Total Capacity of $ATLSPACETOTALMATH TB with $ATLSPACEPROVMATH TB Provisioned and $ATLSPACEUSEDMATH TB Used.`nThis leaves $ATLSPACEFREEMATH TB of Free Space.`n`n"
$BHMPROD=Write-output "Birmingham`n`nThe Birmingham Production Virtual Infrastructure has $BHMPRODVMCount VMs running across $BHMPRODHostCount Hosts.`nThe hosts consist of $BHMPRODCPUTOTALMATH GHZ CPU with $BHMPRODCPUUSEDMATH GHZ of used CPU and $BHMPRODMEMTOTALMATH TB of total memory with $BHMPRODMEMUSEDMATH TB used.`n`n"
$ATLPROD=Write-output "Atlanta`n`nThe Atlanta Production Virtual Infrastructure has $ATLPRODVMCount VMs running across $ATLPRODHostCount Hosts.`nThe hosts consist of $ATLPRODCPUTOTALMATH GHZ CPU with $ATLPRODCPUUSEDMATH GHZ of used CPU and $ATLPRODMEMTOTALMATH TB of total memory with $ATLPRODMEMUSEDMATH TB used.`n`n"
$BHMSF=Write-output "The Birmingham Subscriber Facing infrastructure has $BHMSFVMCount VMs running across $BHMSFHostCount Hosts.`nThe hosts consist of $BHMSFCPUTOTALMATH GHZ CPU with $BHMSFCPUUSEDMATH GHZ of used CPU and $BHMSFMEMTOTALMATH TB of total memory with $BHMSFMEMUSEDMATH TB used.`n`n"
$ATLSF=Write-output "The Atlanta Subscriber Facing infrastructure has $ATLSFVMCount VMs running across $ATLSFHostCount Hosts.`nThe hosts consist of $ATLSFCPUTOTALMATH GHZ CPU with $ATLSFCPUUSEDMATH GHZ of used CPU and $ATLSFMEMTOTALMATH TB of total memory with $ATLSFMEMUSEDMATH TB used.`n`n"
$Overall,$BHMPROD,$BHMSF,$BHMStorage,$ATLPROD,$ATLSF,$ATLStorage | out-file -FilePath C:\Users\achandle\Desktop\Report.txt -Append -Width 200
Send-MailMessage -Attachments C:\Users\achandle\Desktop\Report.txt -From "Monthly LTE Report <vmware@company.com>" -To "slcorsrv@company.com" -Subject "Monthly LTE VMware Report" -SmtpServer "mail.company.com"
Disconnect-viserver * -confirm:$false
Remove-Item C:\Users\achandle\Desktop\Report.txt