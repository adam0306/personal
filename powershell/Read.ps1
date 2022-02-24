Write-Host 'Please enter the IP Address for the vMotion interface.' -ForegroundColor Green
$VMotionIP=Read-Host
Write-Host 'Please enter the Subnet for the vMotion interface.' -ForegroundColor Green
$VMotionSubnet=Read-Host
New-VirtualSwitch -Name “vMotion“ -Nic vmnic3
New-VMHostNetworkAdapter -PortGroup 'vMotion' -VirtualSwitch 'vMotion' -IP $VMotionIP -SubnetMask $VMotionSubnet -VMotionEnabled:$true


Write-Host 'The vMotion network is ready, dummy!' -ForegroundColor Magenta
