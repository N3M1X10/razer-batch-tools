@echo off
chcp 65001>nul
title Razer : Disable

:request-admin-rights
set "arg=%1"
if "%arg%" == "admin" (
    rem echo ! Restarted with admin rights
) else (
    echo [93mRequesting admin rights . . .[0m
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
    exit
)

:razer-shutdown
echo [93mRazer apps stopping . . .[0m
taskkill /f /t /im "Razer Synapse 3.exe"
taskkill /f /t /im "GameManagerService.exe"
taskkill /f /t /im "GameManagerServiceStartup.exe"
taskkill /f /t /im "RazerCentralService.exe"
taskkill /f /t /im "Razer Synapse Service.exe"
taskkill /f /t /im "Razer Synapse Service Process.exe"
taskkill /f /t /im "Razer Central.exe"
taskkill /f /t /im "Razer Updater.exe"

echo.
echo [93mStopping services . . .[0m

echo disabling start type 'RzActionSvc'                & powershell Set-Service -Name 'RzActionSvc' -StartupType Disabled
echo disabling start type 'Razer Synapse Service'      & powershell Set-Service -Name 'Razer Synapse Service' -StartupType Disabled
echo disabling start type 'Razer Game Manager Service' & powershell Set-Service -Name 'Razer Game Manager Service' -StartupType Disabled

echo stopping 'RzActionSvc'                & powershell Stop-Service -Name 'RzActionSvc' -Force
echo stopping 'Razer Synapse Service'      & powershell Stop-Service -Name 'Razer Synapse Service' -Force
echo stopping 'Razer Game Manager Service' & powershell Stop-Service -Name 'Razer Game Manager Service' -Force

:batch-stop
echo.&echo [92m!!!!!  All operations has completed  !!!!![0m
rem >nul timeout /t 3 >nul
pause
endlocal&exit
