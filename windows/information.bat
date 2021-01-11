@echo off

call :sub >output.txt
exit /b

:sub
hostname
ipconfig /all
systeminfo | findstr OS
net user
net localgroup
netstat -ano | findstr LIST | findstr /V ::1 | findstr /V 127.0.0.1
net share