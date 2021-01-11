#!/bin/sh

# May Have to mess around with firewalld
# sudo systemctl stop firewalld
# sudo sysytemctl disable firewalld

# Flush Tables (MAKE SURE TYPED CORRECTLY)
iptables -F
iptables -X

# Accept by default in case of flush
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT

# Allow ICMP
iptables -A INPUT -p ICMP -j ACCEPT
iptables -A OUTPUT -p ICMP -j ACCEPT

# Allow Loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Accept SSH
iptables -A INPUT -p tcp --dport ssh -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

########################
# OTHER OPTIONAL RULES #
########################

# # Iptables Ranges
# iptables -A INPUT -s 10.5.1.0/24 -j ACCEPT
# iptables -A INPUT -s 10.5.2.0/24 -j ACCEPT
# iptables -A INPUT -s 10.x.x.0/24 -j DENY
# iptables -A OUTPUT -s 10.x.x.0/24 -j DENY

# # Allow HTTP Outgoing
# iptables -A OUTPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -A INPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

# # Allow DNS OutGoing
# iptables -A OUTPUT -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -A INPUT  -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

# Accept Various Port
# iptables -A INPUT -p tcp --dport 3000 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -A OUTPUT -p tcp --sport 3000 -m state --state ESTABLISHED -j ACCEPT

# RDP
# iptables -A INPUT -p tcp --dport 3389 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -A OUTPUT -p tcp --sport 3389 -m state --state ESTABLISHED -j ACCEPT

# Drop All Traffic If Not Matching
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP

# Backup Rules (Change Name for Web/No_Web)
iptables-save >/etc/ip_rules

# Anti-Lockout Rule
sleep 3
iptables -F
