@echo off

call :sub >output.txt
exit /b

:sub
::basic inventory
hostname
ipconfig /all
systeminfo | findstr OS

::users and groups
net user
net localgroup

::check for listening ports
netstat -ano | findstr LIST | findstr /V ::1 | findstr /V 127.0.0.1

::looking for network shares
net share

::Check startup programs
reg query HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run
reg query HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce
reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce