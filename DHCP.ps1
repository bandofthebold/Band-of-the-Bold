# IP-tölur
Rename-NetAdapter -Name "Ethernet" -NewName "LAN"
New-NetIPAddress -InterfaceAlias LAN -IPAddress 192.168.1.1 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias LAN -ServerAddresses 127.0.0.1
# AD + DNS
Install-WindowsFeature -Name AD-Domain-Services –IncludeManagementTools
Install-ADDSForest –DomainName bold.local –InstallDNS -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "pass.123" -Force)
# DHCP
Install-WindowsFeature –Name DHCP –IncludeManagementTools
Add-DhcpServerv4Scope -Name BoldScope -StartRange 192.168.1.3 -EndRange 192.168.1.103 -SubnetMask 255.255.255.0
Set-DhcpServerv4OptionValue -DnsServer 192.168.1.1 -Router 192.168.1.1
Add-DhcpServerInDC -DnsName WIN3A-21.bold.local #t.d. $($env:computername + “.” $env:userdnsdomain)
