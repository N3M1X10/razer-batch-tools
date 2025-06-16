@echo off
chcp 65001>nul
setlocal EnableDelayedExpansion


:request-admin-rights
set "arg=%1"
if "%arg%" == "admin" (
    rem echo ! Restarted with admin rights
) else (
    echo [93mRequesting admin rights . . .[0m
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
    exit
)


:razer-wakeup
echo.
echo [93mRestoring Razer services . . .[0m

echo restoring start type 'RzActionSvc'                & powershell Set-Service -Name 'RzActionSvc' -StartupType Automatic
echo restoring start type 'Razer Synapse Service'      & powershell Set-Service -Name 'Razer Synapse Service' -StartupType Automatic
echo restoring start type 'Razer Game Manager Service' & powershell Set-Service -Name 'Razer Game Manager Service' -StartupType Automatic


:batch-stop
echo.&echo [92m^^!^^!^^!^^!^^!  All operations has completed  ^^!^^!^^!^^!^^![0m
rem >nul timeout /t 3 >nul
pause
endlocal&exit
