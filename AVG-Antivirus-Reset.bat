:: ==================================================
::  AVG-Antivirus-Premium-Reset v13.0
:: ==================================================
::  Dev  - Scut1ny
::  Help - AmmarSAA & firebirdjsb
::  Link - https://github.com/Scrut1ny/AVG Antivirus-Premium-Reset
::
::  Note: using this will wipe all your AVG Antivirus settings
::
::  changelog for v13.0: Refactered
:: ==================================================


@echo off
title AVG Antivirus-Premium-Reset ^| v13.0

:: Check for administrator privileges
fltmc >nul 2>&1 || (
    echo( && echo   [33m# Administrator privileges are required. && echo([0m
    PowerShell Start -Verb RunAs '%0' 2> nul || (
        echo   [33m# Right-click on the script and select "Run as administrator".[0m
        >nul pause && exit 1
    )
    exit 0
)

setlocal

:: Define paths
set "MBAM_PATH_X86=%PROGRAMFILES(X86)%\AVG Antivirus\Anti-Malware\AVG Antivirus_assistant.exe"
set "MBAM_PATH_X64=%PROGRAMFILES%\AVG Antivirus\Anti-Malware\AVG Antivirus_assistant.exe"

:: Output header
cls && echo   [\033[94mAVG Antivirus\033[0m: \033[33mPremium\033[0m - [\033[31mBYPASS\033[0m]
echo   --------------------------------

:: Kill AVG Antivirus processes
if exist "%MBAM_PATH_X86%" (
    "%MBAM_PATH_X86%" --stopservice
) else if exist "%MBAM_PATH_X64%" (
    "%MBAM_PATH_X64%" --stopservice
) else (
    echo AVG Antivirus assistant not found in the expected locations.
    exit /b 1
)

taskkill /f /im MBAMService.exe

echo Processes have been killed.
timeout /t 5 >nul

:: Check and delete old scheduled task
echo [+] Querying scheduled task...
timeout /t 5 >nul
schtasks /query /tn "AVG Antivirus-Premium-Reset" >nul 2>&1

if %errorlevel% equ 0 (
    echo [\033[93m!\033[0m] Scheduled task already exists
    echo [+] Deleting old task...
    timeout /t 5 >nul
    schtasks /delete /tn "AVG Antivirus-Premium-Reset" /f >nul 2>&1
    echo [+] Old task deleted.
    timeout /t 2 >nul
)

:: Create new scheduled task
echo [+] Creating scheduled task...
timeout /t 3 >nul
for /f %%a in ('powershell -c "[guid]::NewGuid().ToString()"') do (
    reg add "HKLM\SOFTWARE\Microsoft\Cryptography" /v "MachineGuid" /t REG_SZ /d "%%a" /f >nul
)

schtasks /create /tn "AVG Antivirus-Premium-Reset" /tr "\"%comspec%\" /c \"echo Task executed\"" /sc daily /mo 13 /rl highest >nul 2>&1
echo [+] Scheduled task created.
timeout /t 3 >nul

:: Run the scheduled task
cls
echo   [\033[94mAVG Antivirus\033[0m: \033[33mPremium\033[0m - [\033[31mBYPASS\033[0m]
echo   --------------------------------
echo [+] Running the task...
timeout /t 5 >nul
schtasks /run /tn "AVG Antivirus-Premium-Reset" >nul 2>&1
echo [+] Task executed.
timeout /t 5 >nul

:: Restart AVG Antivirus processes
cls && echo   [\033[94mAVG Antivirus\033[0m: \033[33mPremium\033[0m - [\033[31mBYPASS\033[0m]
echo   --------------------------------
echo [+] Restarting Mbam Processes...
timeout /t 3 >nul
if exist "%MBAM_PATH_X86%" (
    start "" "%MBAM_PATH_X86%" >nul 2>&1
) else if exist "%MBAM_PATH_X64%" (
    start "" "%MBAM_PATH_X64%" >nul 2>&1
) else (
    echo AVG Antivirus assistant not found in the expected locations.
    exit /b 1
)
timeout /t 5 >nul

start "" "%~dp0MBSetup.exe"

pause && echo [+] Done, thank you for using this trial resetter.

endlocal
