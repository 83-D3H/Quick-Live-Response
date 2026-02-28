@echo off
chcp 65001 >nul
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
title DFIR Tool - TEXT ONLY QUICK LIVE RESPONSE

cls
color 0A

echo.
echo ╔─────────────────────────────────────────────────────────────────────────╗
echo │                                                                         │
echo │                                                                         │
echo │    ___        _      _      ____                                        │
echo │   / _ \ _   _(_) ___^| ^| __ ^|  _ \ ___  ___ _ __   ___  _ __  ___  ___   │
echo │  ^| ^| ^| ^| ^| ^| ^| ^|/ __^| ^|/ / ^| ^|_) / _ \/ __^| '_ \ / _ \^| '_ \/ __^|/ _ \  │
echo │  ^| ^|_^| ^| ^|_^| ^| ^| (__^|   ^<  ^|  _ ^<  __/\__ \ ^|_) ^| (_) ^| ^| ^| \__ \  __/  │
echo │   \__\_\\__,_^|_^|\___^|_^|\_\ ^|_^| \_\___^|^|___/ .__/ \___/^|_^| ^|_^|___/\___^|  │
echo │                                           ^|_^|                           │
echo │                                                                         │
echo │                                                                         │
echo ╚─────────────────────────────────────────────────────────────────────────╝
echo.
timeout /t 2 >nul

:: ===== ADMIN CHECK =====
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Please run this script as Administrator.
    pause
    exit /b
)

:: ===== OUTPUT FILE =====
set REPORT=%~dp0Result.txt

:: ===== HEADER =====
echo ======================= DFIR QUICK LIVE RESPONSE ======================= > "%REPORT%"
echo Investigator : 0xD3H >> "%REPORT%"
echo Hostname     : %COMPUTERNAME% >> "%REPORT%"
echo Username     : %USERNAME% >> "%REPORT%"
echo Start Time   : %DATE% %TIME% >> "%REPORT%"
echo ======================================================================= >> "%REPORT%"
echo. >> "%REPORT%"

:: ================= SYSTEM INFORMATION =================
echo [SYSTEM INFORMATION] >> "%REPORT%"
systeminfo >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [SYSTEM BOOT TIME] >> "%REPORT%"
systeminfo | find "Boot" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

:: ================= USER & ACCESS =================
echo [ACTIVE USER SESSIONS] >> "%REPORT%"
query user >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [LOCAL USERS] >> "%REPORT%"
net user >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [LOCAL ADMINISTRATORS] >> "%REPORT%"
net localgroup administrators >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

:: ================= PROCESS INTELLIGENCE =================
echo [RUNNING PROCESSES - VERBOSE] >> "%REPORT%"
tasklist /v >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [PROCESS TO SERVICE MAPPING] >> "%REPORT%"
tasklist /svc >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

:: ================= NETWORK INTELLIGENCE =================
echo [NETWORK CONFIGURATION] >> "%REPORT%"
ipconfig /all >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [ACTIVE NETWORK CONNECTIONS (PID LINKED)] >> "%REPORT%"
netstat -abno >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [ARP TABLE] >> "%REPORT%"
arp -a >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [DNS CACHE] >> "%REPORT%"
ipconfig /displaydns >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

:: ================= PERSISTENCE (CRITICAL) =================
echo [STARTUP FOLDERS] >> "%REPORT%"
dir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" /a >> "%REPORT%" 2>&1
dir "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup" /a >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [REGISTRY RUN KEYS] >> "%REPORT%"
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /s >> "%REPORT%" 2>&1
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /s >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [SCHEDULED TASKS - FULL] >> "%REPORT%"
schtasks /query /fo LIST /v >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [SERVICES IMAGE PATHS] >> "%REPORT%"
reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /v ImagePath >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [WINLOGON PERSISTENCE] >> "%REPORT%"
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /s >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [IFEO HIJACK CHECK] >> "%REPORT%"
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /s >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [APPINIT DLLs] >> "%REPORT%"
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

:: ================= SECURITY CONTROLS =================
echo [FIREWALL STATUS] >> "%REPORT%"
netsh advfirewall show allprofiles >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

:: ================= STORAGE =================
echo [DISK INFORMATION] >> "%REPORT%"
wmic logicaldisk get name,size,freespace >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

:: ================= ENVIRONMENT =================
echo [ENVIRONMENT VARIABLES] >> "%REPORT%"
set >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

:: ================= COMMAND HISTORY =================
echo [COMMAND HISTORY] >> "%REPORT%"
doskey /history >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

:: ================= END =================
echo ======================================================================= >> "%REPORT%"
echo END OF DFIR QUICK TEXT REPORT >> "%REPORT%"
echo End Time : %DATE% %TIME% >> "%REPORT%"
echo ======================================================================= >> "%REPORT%"

echo.
echo [+] DFIR QUICK TEXT COLLECTION COMPLETED
echo [+] Output file created here:
echo     %REPORT%
pause
