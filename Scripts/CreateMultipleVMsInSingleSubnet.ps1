Connect-AzAccount


New-AzResourceGroup -Name TutorialResources -Location 'France Central'


$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

$newVM1 = New-AzVM -ResourceGroupName "TutorialResources" -Name "MyFirstVM" -Location 'France Central' -Image 'Win2016Datacenter' -PublicIpAddressName 'testVMIPAddrNAme' -Credential $cred -OpenPorts 3389

$newVM1

# display computer name, admin user name
$newVM1.OSProfile | Select-Object ComputerName,AdminUserName

$newVM1 | Get-AzNetworkInterface | Select-Object -ExpandProperty IpConfigurations | Select-Object Name,PrivateIpAddress

$publicIp = Get-AzPublicIpAddress -Name testVMIPAddrNAme -ResourceGroupName TutorialResources


$publicIp | Select-Object Name,IpAddress,@{label='FQDN';expression={$_.DnsSettings.Fqdn}}


# create second VM nqmed MySecondVM

$vm2Params = @{
  ResourceGroupName = 'TutorialResources'
  Name = 'MySecondVM'
  ImageName = 'Win2016Datacenter'
  VirtualNetworkName = 'MyFirstVM' #this is the virtual network
  SubnetName = 'MyFirstVM' # this is the subnet
  PublicIpAddressName = 'testVM2PublicIP'
  Credential = $cred
  OpenPorts = 3389
}
$newVM2 = New-AzVM @vm2Params

$newVM2
