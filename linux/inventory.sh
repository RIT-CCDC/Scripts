#!/bin/bash
# OS
echo -e "[OS]\n`cat /etc/os-release`\n"
# Hostname
echo -e "[Hostname]\n`hostname`\n"
# Admin Users
echo -e "[Admins]\n`for g in adm sudo wheel; do getent group $g; done`\n"
# Users
echo -e "[Users]\n`getent passwd | cut -d':' -f1,7`\n"
# IP Address/MACs
echo -e "[IP/MAC]\n`ip -br -c a || ip a`\n"
# Routes
echo -e "[Routes]\n`ip r`\n"
# Services/Ports
echo -e "[Services]\n`ss -tulpan`\n"
