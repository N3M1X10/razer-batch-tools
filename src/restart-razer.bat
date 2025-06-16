:: this script helps me with "Razer Synapse 3" bug, when unable to see my keyboard BlackWidowV3
:: Hope i could help you! <3
:: Source: https://github.com/N3M1X10/RazerSynapse-batch-tools

@echo off
chcp 65001>nul
title Razer : Restart
setlocal EnableDelayedExpansion

:: params

:: if "1" the script will try to restart your keyboard. 
:: Please, provide your keyboard name below
:: with this option SERVICES WILL BE RESTARTED anyway
set fix_keyboard=1
:: Set YOUR 'friendly' keyboard name
set keyboard_name=Razer BlackWidow V3

:: if "1" this will slow down the proccess, but should help with any issues if they will come
:: very valuable function in any cases for troubleshooting
:: disable this only if you sure what you doing!!!
set affect_services=1

:: razer synapse directory path
set synapse=C:\Program Files (x86)\Razer\Synapse3\WPFUI\Framework\Razer Synapse 3 Host

:: if "1" the script will try to hide pop-up windows of the Razer Synapse
set silent=1

:: set time in seconds until autoclose the cmd window
:: 0 if you wouldn't close
set timeout=5

:: if "1" forced apps taskkill. Use if has some issues
set taskkill_force=0

:: end of params



:request-admin-rights
set "arg=%1"
if "%arg%" == "admin" (
    rem echo ! Restarted with admin rights
) else (
    echo [93mRequesting admin rights . . .[0m
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
    exit
)



if %taskkill_force%==1 (
    :: forcing taskkill
    set tk-f=/f
) else (set tk-f=)

:razer-shutdown
echo [93mRazer apps stopping . . .[0m
taskkill %tk-f% /t /im "Razer Synapse 3.exe"
taskkill %tk-f% /t /im "RazerCentralService.exe"
taskkill %tk-f% /t /im "Razer Synapse Service.exe"
taskkill %tk-f% /t /im "GameManagerServiceStartup.exe"
taskkill %tk-f% /t /im "GameManagerService.exe"
taskkill %tk-f% /t /im "Razer Synapse Service Process.exe"
taskkill %tk-f% /t /im "Razer Central.exe"
taskkill %tk-f% /t /im "Razer Updater.exe"


if %affect_services%==1 (
    rem do nothing
) else if %fix_keyboard%==1 (
    rem do nothing
) else (
    :: skip function if not match any conditions
    goto :skip-stopping-services
)

echo.
echo [93mStopping services . . .[0m

echo disabling start type 'RzActionSvc'                & powershell Set-Service -Name 'RzActionSvc' -StartupType Disabled
echo disabling start type 'Razer Synapse Service'      & powershell Set-Service -Name 'Razer Synapse Service' -StartupType Disabled
echo disabling start type 'Razer Game Manager Service' & powershell Set-Service -Name 'Razer Game Manager Service' -StartupType Disabled

echo stopping 'RzActionSvc'                & powershell Stop-Service -Name 'RzActionSvc' -Force
echo stopping 'Razer Synapse Service'      & powershell Stop-Service -Name 'Razer Synapse Service' -Force
echo stopping 'Razer Game Manager Service' & powershell Stop-Service -Name 'Razer Game Manager Service' -Force
:skip-stopping-services



:reboot-keyboard
if %fix_keyboard%==1 (
    echo.
    cd /d "%~dp0"
    echo [93mRestarting your keyboard . . .[0m
    
    rem powershell
    powershell -Command ^
    "$keyboard_name = '!keyboard_name!';"^
    ""^
    "Write-Host 'Trying to restart your keyboard:', """"'$keyboard_name'"""" -Foregroundcolor Yellow;"^
    ""^
    "function restartPnP($device) {"^
      "try {"^
        "<# try to restart each pnp-obj of this device #>"^
        "$device | Foreach-Object {"^
          "Write-Host $_.InstanceId -Foregroundcolor Cyan;"^
          "Write-Host 'First of all, im trying command: """"pnputil /enable-device"""" by security reason' -Foregroundcolor Yellow;"^
          "pnputil /enable-device $_.InstanceId;"^
          "Write-Host 'Now im trying to restart your keyboard to fix some problems' -Foregroundcolor Yellow;"^
          "pnputil /restart-device $_.InstanceId;"^
        "}"^
      "}"^
      "catch {"^
          "Write-Output 'Error:', $($_.Exception.Message) -Foregroundcolor Red;"^
      "}"^
    "}"^
    ""^
    "while ($true) {"^
      "<# Try to find the pnp device #>;"^
      "$device = Get-PnpDevice | Where-Object {$_.FriendlyName -like $keyboard_name};"^
      "if ($device) {"^
        "restartPnP($device);"^
        "break"^
      "}"^
      "else {"^
        "Write-Host "Device """"'!keyboard_name!'"""" has not found" -Foregroundcolor Red;"^
        "break"^
      "};"^
    "}"
    echo Done

    rem old method
    rem USB Deview
    rem These usb names are unique! Please check your keyboard names in utility: bin/USBDeview.exe

    rem if exist "bin/USBDeview.exe" (
    rem      echo usb deview
    rem      start "bin/" "bin/USBDeview.exe" /RunAsAdmin /disable_enable "HID\VID_1532&PID_024E&MI_01&COL01\7&A639AA&0&0000"
    rem      echo Done
    rem ) else (echo [91mThe utility not found: "%~dp0bin\USBDeview.exe"[0m &pause)

) else (echo Keyboard Restarting is skipped)



:razer-wakeup

if %affect_services%==1 (
    rem do nothing
) else if %fix_keyboard%==1 (
    rem do nothing
) else (
    :: skip function if not match any conditions
    goto :skip-starting-services
)


echo.
echo [93mStarting Razer services . . .[0m

echo restoring start type 'RzActionSvc'                & powershell Set-Service -Name 'RzActionSvc' -StartupType Automatic
echo restoring start type 'Razer Synapse Service'      & powershell Set-Service -Name 'Razer Synapse Service' -StartupType Automatic
echo restoring start type 'Razer Game Manager Service' & powershell Set-Service -Name 'Razer Game Manager Service' -StartupType Automatic

echo starting 'RzActionSvc'                & powershell Start-Service -Name 'RzActionSvc'
echo starting 'Razer Synapse Service'      & powershell Start-Service -Name 'Razer Synapse Service'
echo starting 'Razer Game Manager Service' & powershell Start-Service -Name 'Razer Game Manager Service'
:skip-starting-services


echo.
cd /d "!synapse!"

echo [93mStarting Razer Synapse App . . .[0m
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
echo Press any key to exit . . .
if %timeout% gtr 0 (
    timeout /t %timeout%
) else (
    pause>nul
)
endlocal&exit
