#Setup which host to target
$VMhost = 'xxxx'
#create vSwitch2 for storage, add vmnics, add two vmkernels with Storage IPs, setup NIC teaming (based on the fact you probably have vSwitch0 for mgmt and vSwitch1 for VM traffic)
$vs2 = get-vmhost $VMhost | new-virtualswitch -Name vSwitchISCSI -Nic 'vmnic19','vmnic13' -Mtu 9000 -NumPorts 120
New-VMHostNetworkAdapter -VMhost $VMhost -virtualswitch $vs2 -portgroup iSCSI0 -ip x.x.x.x -subnetmask 255.255.255.0 -Mtu 9000
New-VMHostNetworkAdapter -VMhost $VMhost -virtualswitch $vs2 -portgroup iSCSI1 -ip x.x.x.x -subnetmask 255.255.255.0 -Mtu 9000
Get-VirtualPortGroup -VMhost $host -virtualswitch $vs2 -Name iSCSI0 | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicActive vmnic2 -MakeNicUnused vmnic13
Get-VirtualPortGroup -VMhost $host -virtualswitch $vs2 -Name iSCSI1 | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicActive vmnic5 -MakeNicUnused vmnic19
#Create Software iSCSI Adapter
get-vmhoststorage $VMhost | set-vmhoststorage -softwareiscsienabled $True
#Get Software iSCSI adapter HBA number and put it into an array
$HBA = Get-VMHostHba -VMHost $VMHost -Type iSCSI | %{$_.Device}
#Set your VMKernel numbers, Use ESXCLI to create the iSCSI Port binding in the iSCSI Software Adapter,
$vmk1number = 'vmk13'
$vmk2number = 'vmk19'
$esxcli = Get-EsxCli -VMhost $VMhost
$Esxcli.iscsi.networkportal.add($HBA, $Null, $vmk1number)
$Esxcli.iscsi.networkportal.add($HBA, $Null, $vmk2number)
#Setup the Discovery iSCSI IP addresses on the iSCSI Software Adapter
$hbahost = get-vmhost $VMhost | get-vmhosthba -type iscsi
new-iscsihbatarget -iscsihba $hbahost -address IP_ADDR
#Rescan the HBA to discover any storage
get-vmhoststorage $VMhost -rescanallhba -rescanvmfs

test
