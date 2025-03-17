@echo off
chcp 65001>nul
title Razer : Restart
setlocal

:: this batch helps me with "Razer Synapse 3" bug, when he unable to see my keyboard BlackWidowV3

::keyboard fix
set fix_keyboard=1

:: synapse path
set synapse=C:\Program Files (x86)\Razer\Synapse3\WPFUI\Framework\Razer Synapse 3 Host

:: Restart with Admin Rights
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
    exit
)

:razer-off
cls
echo ! Razer stop
taskkill /f /im "Razer Synapse 3.exe" /t
taskkill /f /im "GameManagerService.exe" /t
taskkill /f /im "GameManagerServiceStartup.exe" /t
taskkill /f /im "RazerCentralService.exe" /t
taskkill /f /im "Razer Synapse Service.exe" /t
taskkill /f /im "Razer Synapse Service Process.exe" /t
taskkill /f /im "Razer Central.exe" /t
taskkill /f /im "Razer Updater.exe" /t
>nul timeout /t 1 /nobreak

echo ! set service disabled &powershell Set-Service -Name 'Razer Game Manager Service' -StartupType Disabled
echo ! set service disabled &powershell Set-Service -Name 'Razer Synapse Service' -StartupType Disabled
echo ! set service disabled &powershell Set-Service -Name 'RzActionSvc' -StartupType Disabled

echo ! stop service &powershell Stop-Service -Name 'Razer Game Manager Service' -Force
echo ! stop service &powershell Stop-Service -Name 'Razer Synapse Service' -Force
echo ! stop service &powershell Stop-Service -Name 'RzActionSvc' -Force

:reboot-keyboard
if %fix_keyboard%==1 (
:: This usb names are unique! Please check your keyboard names in: bin/USBDeview.exe
cls
cd /d "%~dp0"
if exist "bin/USBDeview.exe" (
echo ! Restart keyboard
start "bin/" "bin/USBDeview.exe" /RunAsAdmin /disable_enable "USB\VID_1532&PID_024E&MI_02\6&3860e76&0&0002"
>nul timeout /t 1 /nobreak
start "bin/" "bin/USBDeview.exe" /RunAsAdmin /disable_enable "USB\VID_1532&PID_024E&MI_01\6&3860e76&0&0001"
>nul timeout /t 1 /nobreak
echo ! Restarted
) else (echo The utility is missing: USBDeview &pause)
)

:razer-on
cls
echo ! Razer start

echo ! set service automatic &powershell Set-Service -Name 'Razer Game Manager Service' -StartupType Automatic
echo ! set service automatic &powershell Set-Service -Name 'Razer Synapse Service' -StartupType Automatic
echo ! set service automatic &powershell Set-Service -Name 'RzActionSvc' -StartupType Automatic

echo ! start service &powershell Start-Service -Name 'Razer Game Manager Service'
echo ! start service &powershell Start-Service -Name 'Razer Synapse Service'
echo ! start service &powershell Start-Service -Name 'RzActionSvc'

cd /d "%synapse%"
echo Razer App starting . . . &start "" "%synapse%\Razer Synapse 3.exe"


:batch-stop
endlocal
echo.&echo [33mEND &>nul timeout /t 2
exit
