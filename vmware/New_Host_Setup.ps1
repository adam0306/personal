#Set SNMP receivers and community names.
#Set syslog servers
#set NTP
#Create iSCSI Switch
#Create vMotion Switch
#Create Traffic Switch
#Create Fault Tolerance Switch

Set-VMHostSNMP
Set-VMHostSysLogServer -SysLogServer '192.168.0.1:133' -VMHost Host
Add-VMHostNtpServer
New-VirtualSwitch -VMHost $VMHost -Name “vSwitch1“ -Nic “nic1“
$VMotionIP = “192.168.0.1“
$VMotionSubnet = “255.255.255.0“
New-VirtualSwitch -VMHost $VMHost -Name “vSwitch2“ -Nic “nic1“
New-VirtualSwitch -VMHost $VMHost -Name “vSwitch3“ -Nic “nic1“
New-VirtualSwitch -VMHost $VMHost -Name “vSwitch4“ -Nic “nic1“

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

#Customisation: Lesson 1 – Time Source
#Customisation: Lesson 2 – Service and Firewall Configuration
#Lets get down and dirty, by now you should not only starting to become familiar with the way things are working but also probably trying new things out, Great !
#Now, as there are multiple ways of configuring your vSwitches/Portgroups and Nics I will explain a few ways that should show you the basics, everything else you should be able to work out from there.  As always any questions or comments are welcome !
#So, the first thing we need to do is think about how we would configure this without scripts, often when I am writing a script I will write down the procedure a step at a time following it through in the GUI, I will then convert this into a script.
#So to setup our networks if we have a good networks team or have patched the servers ourselves we would have consistent nic patching, lets keep it easy for this example but you can obviously go wild !
#So for this example I will choose the following configuration:
#nic0 –> Service Console
#nic1 –> VMotion
#nic2 –> VLAN Trunked Network #1
#nic3 –> VLAN Trunked Network #1
#nic4 –> VLAN Trunked Network #2
#nic5 –> VLAN Trunked Network #2
#I know this doesn’t keep to best practice etc etc but lets keep it easy for the examples.
#So first thing we would do during the build is add the IP address to vSwitch0 and choose our nic to use with the service console so that’s sorted.
#Second I normally setup the VMotion (or vMotion depending on which VMware doc you read) network, this we can do by the following:
New-VirtualSwitch -VMHost $VMHost -Name “vSwitch1“ -Nic “nic1“
#I don’t think I have to explain that line to you !
#Now we need to set the VMotion IP address and subnet mask and tick the box that says we are going to use this portgroup which i have called ‘VMotion’ for VMotion, here’s the few lines of code:
$VMotionIP = “192.168.0.1“
$VMotionSubnet = “255.255.255.0“
New-VMHostNetworkAdapter -PortGroup “VMotion“ -VirtualSwitch “vSwitch1“ -IP $VMotionIP -SubnetMask $VMotionSubnet -VMotionEnabled:$true
#So the first line stores our VMotion IP address, the second stores our subnet and the third works our magic, it adds both of our settings to the vSwitch and at the end it ticks the box to say we want to use it for VMotion.
#Next, we want to setup our VLAN Tagged vSwitches, I’m sure you have already worked out the vSwitch part of things but just in case:
$VMNetwork1Nics=“vmnic2“,“vmnic3“
New-VirtualSwitch -VMHost $VMHost -Name “vSwitch2“ -Nic $VMNetwork1Nics
#and for the second VM vSwitch (if you didnt work this one out then quit now!):
$VMNetwork2Nics=“vmnic4“,“vmnic5“
New-VirtualSwitch -VMHost $VMHost -Name “vSwitch3“ -Nic $VMNetwork2Nics
#So now we have all our vSwitches setup and attached to our nics, we also have our VMotion setup nicely, go for a coffee and we will cover how to add Portgroups to these vSwitches, I have a very nice trick too, stay tuned for the next exciting episode !
#Our Script so far:


Add-VMHostNtpServer -VMHost $VMHost -NtpServer ‘ntp.mycompany.com‘
Get-VmHostService -VMHost $VMHost |Where-Object {$_.key-eq “ntpd“} |Start-VMHostService
Get-VmhostFirewallException -VMHost $VMHost -Name “NTP Client“ |Set-VMHostFirewallException -enabled:$true
Get-VmhostFirewallException -VMHost $VMHost -Name “SNMP Server“  |Set-VMHostFirewallException -enabled:$true
New-VirtualSwitch -VMHost $VMHost -Name “vSwitch1“ -Nic “nic1“
$VMotionIP = “192.168.0.1“
$VMotionSubnet = “255.255.255.0“
New-VMHostNetworkAdapter -PortGroup “VMotion“ -VirtualSwitch “vSwitch1“ -IP $VMotionIP -SubnetMask $VMotionSubnet -VMotionEnabled:$true
$VMNetwork1Nics=“vmnic2“,“vmnic3“
New-VirtualSwitch -VMHost $VMHost -Name “vSwitch2“ -Nic $VMNetwork1Nics
$VMNetwork2Nics=“vmnic4“,“vmnic5“
New-VirtualSwitch -VMHost $VMHost -Name “vSwitch3“ -Nic $VMNetwork2Nics