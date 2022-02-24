So to change all virtual machines we would do the following:
$OldNetwork = "PG1 192.168.0" 
$NewNetwork = "PG2 10.1.1"
Get-VM |Get-NetworkAdapter |Where {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -NetworkName $NewNetwork -Confirm:$false
Or to change all of the VMs for a particular cluster we could use:
$Cluster = "Non-Production" 
$OldNetwork = "PG1 192.168.0" 
$NewNetwork = "PG2 10.1.1"
Get-Cluster $Cluster |Get-VM |Get-NetworkAdapter |Where {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -NetworkName $NewNetwork -Confirm:$false
Note: By default the Set-NetworkAdapter cmdlet would prompt you for each change it was going to make, this is overwritten by using the –Confirm:$false parameter.
VESI
This can also be achieved from the VESI by:
Connect to a managed host
Select Virtual Machines
Select the virtual machines from the grid view which you would like to change
Click ‘Network Adapters’ from the links pane on the right
Filter the grid view to only display the adapters attached to a certain Network Name
Click ‘Change Properties’ from the Actions pane on the right and enter a new NetworkName as seen below