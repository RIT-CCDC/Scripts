#!/bin/bash

indent() { sed 's/^/\t/g'; }

# OS
echo "[+] OS:"
cat /etc/os-release | indent

# Hostname
echo "[+] Hostname:"
hostname | indent

# Admin Users
echo "[+] Admins:"
for i in adm sudo wheel; do getent group $i | indent; done

# Users
echo "[+] Users:"
getent passwd | cut -d':' -f1,7| indent

# IP Address/MACs
echo "[+] IP/MAC:"
ip -br -c a  | indent || ip a | indent

# Routes
echo "[+] Routes:"
ip r | indent

# Services/Ports
echo "[+] Services:"
ss -tulpan | indent
