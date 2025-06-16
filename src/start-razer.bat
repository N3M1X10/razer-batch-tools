@echo off
chcp 65001>nul
setlocal EnableDelayedExpansion


:: synapse path
set synapse=C:\Program Files (x86)\Razer\Synapse3\WPFUI\Framework\Razer Synapse 3 Host

set silent=1


:request-admin-rights
set "arg=%1"
if "%arg%" == "admin" (
    rem echo ! Restarted with admin rights
) else (
    echo [93mRequesting admin rights . . .[0m
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
    exit
)


:razer-on
echo.
echo [93mStarting Razer services . . .[0m

echo restoring start type 'RzActionSvc'                & powershell Set-Service -Name 'RzActionSvc' -StartupType Automatic
echo restoring start type 'Razer Synapse Service'      & powershell Set-Service -Name 'Razer Synapse Service' -StartupType Automatic
echo restoring start type 'Razer Game Manager Service' & powershell Set-Service -Name 'Razer Game Manager Service' -StartupType Automatic

echo starting 'RzActionSvc'                & powershell Start-Service -Name 'RzActionSvc'
echo starting 'Razer Synapse Service'      & powershell Start-Service -Name 'Razer Synapse Service'
echo starting 'Razer Game Manager Service' & powershell Start-Service -Name 'Razer Game Manager Service'


echo [93mStarting Razer Synapse App . . .[0m
cd /d "%synapse%"
start "" /min "Razer Synapse 3.exe"

if %silent%==1 (
    echo [93mAnd trying to hide this pop-up garbage from your eyes . . .[0m
    powershell -Command ^
    " while ($true) { "^
    "   $process = Get-Process | Where-Object {$_.MainWindowTitle -eq 'Razer Synapse'}; "^
    "   if ($process) { "^
    "       Write-Host 'I have sent commands to close these garbage windows^!' -Foregroundcolor Green; "^
    "       $process.CloseMainWindow() | Out-Null;  "^
    "       break; "^
    "       exit 0 "^
    "   } "^
    " } "
)


:batch-stop
echo.&echo [92m^^!^^!^^!^^!^^!  All operations has completed  ^^!^^!^^!^^!^^![0m
rem >nul timeout /t 3 >nul
pause
endlocal&exit
