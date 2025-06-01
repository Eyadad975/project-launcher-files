@echo off
set menu1choice=undefined
goto :menu1

:menu1
title Main Menu
powershell -Command "Write-Host 'Welcome to ' -NoNewline; Write-Host 'Eyadad Tool!' -ForegroundColor Green -BackgroundColor White -NoNewline; Write-Host ' Release Version 1.0'"

echo.
echo.
echo What do you want to do?
echo 1) WINSYSFETCH
echo 2) Quick Search
echo 3) WiFi Password Export
echo 4) Quick Add To Clipboard
echo 5) Export Network Info
set /p menu1choice=Choice: 
if %menu1choice%==1 goto WINSYSFETCH
if %menu1choice%==2 goto QuickS
if %menu1choice%==3 goto passexport
if %menu1choice%==4 goto Clipboardadd
if %menu1choice%==5 goto Networkinfo
goto :failchoice
set menu1choice=undefined

:Networkinfo
set report=%~dp0network_report.txt

:: Clear previous report and add header with timestamp
(
  echo ===== %username%'s Network Report =====
  echo =====  Eyadad Network Info Tool   =====
  echo Generated on: %date% %time%
  echo.
) > "%report%"

:: Export Listening Ports
echo === LISTENING PORTS === >> "%report%"
powershell -Command "Get-NetTCPConnection -State Listen | Select-Object LocalAddress,LocalPort,OwningProcess | Sort-Object LocalPort | Format-Table -AutoSize | Out-String" >> "%report%"

:: Export Established Connections
echo. >> "%report%"
echo === ESTABLISHED CONNECTIONS === >> "%report%"
powershell -Command "Get-NetTCPConnection -State Established | Select-Object LocalAddress,LocalPort,RemoteAddress,RemotePort,OwningProcess | Format-Table -AutoSize | Out-String" >> "%report%"

:: Export Public IP
echo. >> "%report%"
echo === PUBLIC IP === >> "%report%"
powershell -Command "(Invoke-RestMethod 'https://api.ipify.org?format=json').ip" >> "%report%"
echo Export Successful. Press any key to go back to menu...
pause >nul
timeout /t 2 /NOBREAK >nul
cls
goto :menu1




:Clipboardadd
echo.
set /p clipboardwant=What do you want to add to your clipboard(warning: only 1 line supported)? 
echo "%clipboardwant%" | clip
echo.
echo Added "%clipboardwant%" successfully to Clipboard
echo.
echo Press any key to go back to menu...
pause >nul
timeout /t 2 /NOBREAK >nul
cls
set menu1choice=undefined
set clipboardwant=undefined
goto :menu1

:passexport
setlocal

:: Get the folder where the batch file is running
set "script_dir=%~dp0"

:: Download the PS1 file from GitHub to a temp file in this folder
set "ps1_file=%script_dir%wifi.ps1"

:: Use PowerShell to download the PS1 script
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Eyadad975/project-launcher-files/main/wifi.ps1' -OutFile '%ps1_file%'"

:: Run the PS1 script with PowerShell, making sure the working directory is the batch folder
powershell -NoProfile -ExecutionPolicy Bypass -File "%ps1_file%" -WorkingDirectory "%script_dir%"
echo Press any key to go back to menu...
pause >nul
endlocal
timeout /t 2 /NOBREAK >nul
cls
set menu1choice=undefined
goto :menu1
  
:QuickS
setlocal

set /p query=Enter search query: 

powershell -NoProfile -Command ^
  "$q = [System.Net.WebUtility]::UrlEncode('%query%');" ^
  "$url = 'https://www.google.com/search?q=' + $q;" ^
  "Start-Process $url"

endlocal
echo Press any key to go back to menu...
pause >nul
timeout /t 2 /NOBREAK >nul
cls
set menu1choice=undefined
goto :menu1


:validfordebug
set menu1choice=undefined
echo Valid!
goto menu1

:failchoice
cls
echo No value found redirecting to main menu...
timeout /t 1 /nobreak >nul
goto :menu1

:WINSYSFETCH
set menu1choice=undefined
title WINSYSFETCH v1.0

:: Header
echo.
echo ===========================
echo      WINSYSFETCH v1.0       
echo ===========================
echo.

@echo off
setlocal

REM --- URL of your raw PowerShell script on GitHub ---
set "PSURL=https://raw.githubusercontent.com/Eyadad975/project-launcher-files/refs/heads/main/ddd.ps1"

REM --- Temp file path to save the script ---
set "TempPS=%temp%\sysfetch.ps1"

REM --- Download the PowerShell script ---
powershell -Command "Invoke-WebRequest -Uri '%PSURL%' -OutFile '%TempPS%'"

REM --- Run the PowerShell script ---
powershell -NoProfile -ExecutionPolicy Bypass -File "%TempPS%"

echo Press any key to go back to menu...
pause >nul
timeout /t 2 /NOBREAK >nul
cls
goto :menu1

