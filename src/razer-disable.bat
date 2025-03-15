@echo off
chcp 65001>nul
title Razer : Disable

:razer-off
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

echo.&echo END &pause>nul&exit
