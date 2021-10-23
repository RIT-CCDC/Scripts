netsh advfirewall set allprofiles state off
netsh advfirewall set allprofiles firewallpolicy allowinbound,allowoutbound
netsh advfirewall firewall delete rule name=all

netsh adv f a r n="WSA-LoopOut" dir=out act=allow remoteip=127.0.0.1
netsh adv f a r n="WSA-LoopIn" dir=in act=allow remoteip=127.0.0.1

netsh adv firewall a r n="WSA-PingIn" dir=in act=allow prof=any prot=icmpv4:8,any 
netsh adv firewall a r n="WSA-PingOut" dir=out act=allow prof=any prot=icmpv4:8,any 

netsh adv f a r n="WSA-HTTP-Client" dir=out act=allow prof=any prot=tcp remoteport=80,443
netsh adv f a r n="WSA-HTTP-Server" dir=in act=allow prof=any prot=tcp localport=80,443

netsh adv f a r n="WSA-SMB-Server" dir=in act=allow prof=any prot=tcp localport=445

netsh advfirewall firewall add rule name="WSA-RDP-TCP-Server" dir=in protocol=tcp localport=3389 action=allow
netsh advfirewall firewall add rule name="WSA-RDP-UDP-Server" dir=in protocol=udp localport=3389 action=allow

netsh adv f a r n="WSA-DNS-Client" dir=out act=allow prof=any prot=udp remoteport=53
netsh adv f a r n="WSA-DNS-Server" dir=in act=allow prof=any prot=udp localport=53

netsh adv f a r n="WSA-DomainClient TCP" dir=out act=allow prof=any prot=tcp remoteport=88,135,389,445,636,3268,10000-11000 remoteip=10.10.1.10
netsh advf f a r n="WSA-DomainClient-UDP" dir=out act=allow prof=any prot=udp remoteport=88,123,135,389,445,636 remoteip=10.10.1.10

netsh adv f a r n="WSA-DC-TCP-In" dir=in act=allow prof=any prot=tcp localport=88,135,139,389,445,636,3268
netsh adv f a r n="WSA-DC-UDP-In" dir=in act=allow prof=any prot=udp localport=88,123,135,139,389,445,636

netsh advfirewall firewall add rule name="WSA-GP" dir=out program="C:\Windows\System32\svchost.exe" remoteip=10.10.1.10 action=allow enable=yes profile=any
netsh advfirewall firewall add rule name="WSA-GP" dir=out program="C:\Windows\System32\lsass.exe" remoteip=10.10.1.10 action=allow enable=yes profile=any

netsh interface ipv4 set dynamicportrange tcp 10000 1000 persistent
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockinbound

netsh advfirewall set allprofiles state on

