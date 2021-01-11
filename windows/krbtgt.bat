@echo off
for /L %a in (1,0,2) do @(set rand=%RANDOM% & net user krbtgt %rand% & net user krbtgt %rand%) & timeout /t 120
