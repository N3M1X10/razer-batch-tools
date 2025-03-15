@echo off
chcp 65001>nul
setlocal

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

:razer-on
cls
title Razer : Start

echo ! set service automatic &powershell Set-Service -Name 'Razer Game Manager Service' -StartupType Automatic
echo ! set service automatic &powershell Set-Service -Name 'Razer Synapse Service' -StartupType Automatic
echo ! set service automatic &powershell Set-Service -Name 'RzActionSvc' -StartupType Automatic

echo ! start service &powershell Start-Service -Name 'Razer Game Manager Service'
echo ! start service &powershell Start-Service -Name 'Razer Synapse Service'
echo ! start service &powershell Start-Service -Name 'RzActionSvc'

cd /d "%synapse%"
echo Razer App starting . . . &start "" "%synapse%\Razer Synapse 3.exe"

endlocal
exit