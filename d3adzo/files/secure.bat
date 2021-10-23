REM  Run this script in an elevated CMD prompt
REM  This does not include firewall rules
REM Comment out any sections that do not apply to a certain service (ex. SMB scored box)
REM Don't forget to use msconfig


REM sc.exe config “wfcs” displayname= “wfcservice”
REM sc.exe description wfcs “wfcservice description”
REM perm charlie delta
@echo off

REM rename admin acct + disable default accounts
REM wmic useraccount where "name='Administrator'" rename Admin
REM net user Administrator /active:no
net user Guest /active:no
net user DefaultAccount /active:no
net user WDAGUtilityAccount /active:no


REM Enable full auditing
auditpol /set /category:* /success:enable /failure:enable


REM  delete scheduled tasks (might break AD box)
REM schtasks /delete /tn *


REM Secure RDP
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v SecurityLayer /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 1 /f


REM Disable RDP
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v fLogonDisabled /t REG_DWORD /d 1 /f


REM Disable Admin Shares (psexec defense)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v AutoShareWks /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v AutoShareServer /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /d 0 /f


REM WinRM Killer (only uncomment if winrm is not needed)
cd C:\Windows\System32
net stop winrm
sc config winrm start=disabled
takeown.exe /f WsmSvc.dll
icacls WsmSvc.dll /grant "Administrator:(F)"
del WsmSvc.dll /f


REM SMBv1 Disable 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Services\LanmanServer\Parameters" /v SMB1 /t REG_DWORD /d 1 /f


REM Temp Folder Permissioning (might break installers)
icacls C:\Windows\Temp /inheritance:r /deny "Everyone:(OI)(CI)(F)"


REM Hashing
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v NoLMHash /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LMCompatibilityLevel /t REG_DWORD /d 5 /f


REM Anon Login
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v restrictanonymous /t REG_DWORD /d 1 /f
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v disableRestrictedAdmin /t REG_DWORD /d 0 /f 


REM Disable Keys
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58 /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 122 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v ShowTabletKeyboard /t REG_DWORD /d 0 /f


REM pagefile wipe on shutdown (causing issues)
REM reg ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f


REM disable floppy disk remoting
reg ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AllocateFloppies /t REG_DWORD /d 1 /f


REM Enable SMB Signing (prevent smb ntlm relaying attacks)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Services\LanmanServer\Parameters" /v EnableSecuritySignature /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Services\LanmanServer\Parameters" /v RequireSecuritySignature  /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Rdr\Parameters" /v EnableSecuritySignature /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Rdr\Parameters" /v RequireSecuritySignature /t REG_DWORD /d 1 /f



REM Prevent print driver installs 
reg ADD "HKLM\SYSTEM\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers" /v AddPrinterDrivers /t REG_DWORD /d 1 /f


REM local account blank passwords
reg ADD "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 1 /f


REM  enable full uac
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f


REM BITS transfer disable
reg add HKLM\Software\Policies\Microsoft\Windows\BITS /v EnableBITSMaxBandwidth /t REG_DWORD /d 0 /f
reg add HKLM\Software\Policies\Microsoft\Windows\BITS /v MaxDownloadTime /t REG_DWORD /d 1 /f


REM Enable installer detections
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableInstallerDetection /t REG_DWORD /d 1 /f


REM anon enumeration prevention
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v restrictanonymous /t REG_DWORD /d 1 /f 
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v restrictanonymoussam /t REG_DWORD /d 1 /f 


REM domain cred storing 
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v disabledomaincreds /t REG_DWORD /d 1 /f 

REM no perms to anons
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v everyoneincludesanonymous /t REG_DWORD /d 0 /f 


REM smb strengtheners
reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanWorkstation\Parameters /v EnablePlainTextPassword /t REG_DWORD /d 0 /f
reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v NullSessionPipes /t REG_MULTI_SZ /d "" /f
reg ADD HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters /v NullSessionShares /t REG_MULTI_SZ /d "" /f


REM remote registry path denial
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg\AllowedExactPaths /v Machine /t REG_MULTI_SZ /d "" /f
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg\AllowedPaths /v Machine /t REG_MULTI_SZ /d "" /f


REM Disable IPv6
reg ADD HKLM\SYSTEM\CurrentControlSet\services\tcpip6\parameters /v DisabledComponents /t reg_dword /d 255 /f


REM No process RunOnce List
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v DisableLocalMachineRunOnce /t REG_DWORD /d 1 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v DisableLocalMachineRunOnce /t REG_DWORD /d 1 /f


REM Require UAC
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated /t REG_DWORD /d 0 /f


REM  Enable LSASS Memory Protection
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v RunAsPPL /t REG_DWORD /d 1 /f


REM Enable Credential Guard
reg add "HKLM\SYSTEM\CurrentControl\Control\Lsa" /v LsaCfgFlags /t REG_DWORD /d 1 /f


REM Disable plain text passwords stored in LSASS
reg add HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest /v UseLogonCredential /t REG_DWORD /d 0 /f 


REM Enable PowerShell Logging
reg add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ModuleLogging" /v EnableModuleLogging /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" /v EnableScriptBlockLogging /t REG_DWORD /d 1 /f


net share admin$ /del
net share c$ /del
reg delete hklm\software\microsoft\windows\currentversion\runonce /f
reg delete hklm\software\microsoft\windows\currentversion\run /f
del /S "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*"
del /S "C:\Users\LocalGuard\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*"
REG delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sethc.exe" /v Debugger /f
REG delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\utilman.exe" /v Debugger /f 



REM  Turn off Test Mode (in case they set the flag)
bcdedit /set testsigning off
