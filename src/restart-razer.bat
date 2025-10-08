:: this script helps me with "Razer Synapse 3" bug, when unable to see my keyboard BlackWidowV3
:: Hope i could help you! <3
:: Source: https://github.com/N3M1X10/razer-batch-tools

@echo off
chcp 65001>nul
title Razer : Restart
setlocal EnableDelayedExpansion


:Params

:: if "1" the script will try to restart your keyboard. 
:: Please, provide your keyboard name below
:: with this option SERVICES WILL BE RESTARTED anyway
:: default: '1'
set fix_keyboard=1
:: Set YOUR 'friendly' keyboard name
set keyboard_name=Razer BlackWidow V3

:: if "1" this will slow down the proccess, but should help with any issues if they will come
:: this function may help in any cases for troubleshooting
:: disable this only if you sure what you doing!!!
:: default: ''
set affect_services=

:: if "1" the script will try to hide pop-up windows of the Razer Synapse
:: default: '1'
set silent=1

:: ask to continue, before doing that things
:: default: '0'
set ask_before=0

:: sets whether the window will be hidden
:: [1 / or any else value]
:: default: '0'
set windowless=1


:Dev-Params
::debug mode
:: [1 / or any else val]
:: 1 - sets timeout to '60'
:: default: '0'
set debug=0

:: this option will set this script to request admin rights
:: this option REQUIRED to correct working of this script, and added only for very specific debugging
:: [1 / or any else val]
:: default: '1'
set require_admin=1

:: set time in seconds until autoclose the cmd window
:: "0" if you wouldn't close
:: default: '2'
set timeout=2

:: if "1" forced apps taskkill. Use "0" if has some issues
:: default: '1'
set taskkill_force=1

::Mode
:: Sets whether the script will be in restart mode. 
:: [1 / or any val]
:: 1 - sets that the script is should restart the razer
set mode=1


:Constant-Params

:: razer synapse3 working directory path
set synapse3=C:\Program Files (x86)\Razer\Synapse3\WPFUI\Framework\Razer Synapse 3 Host

:: razer synapse4 working directory path
set synapse4=C:\Program Files\Razer\RazerAppEngine

set adm_arg=%1
set hdn_arg=%2

:End-Of-Params



:begin
call :initialize
call :razer-shutdown "disable"
if "%mode%"=="1" (
    call :reboot-keyboard
    call :razer-wakeup   
)




:close
echo.&echo [92m^^!^^!^^!^^!^^!  All operations has completed  ^^!^^!^^!^^!^^![0m

if "%debug%"=="1" (set timeout=60)

if "%timeout%" gtr "0" (
    echo Press any key to exit . . .
    timeout /t %timeout%
) else (
    pause
)
endlocal&exit



:initialize
if "%ask_before%"=="1" (
    :: keep window on screen - anyway
    set windowless=0
    :: calls to admin rights
    call :request-admin-rights
    :: ask user to continue
    call :ask-before
) else (
    call :request-admin-rights
)

::try to define synapse version
if exist "!synapse4!" (
rem init the Synapse4

set synapse=!synapse4!
set synapse_version=4

) else if exist "!synapse3!" (
rem init the Synapse3

set synapse=!synapse3!
set synapse_version=3

) else (
    rem error
    msg * [%~n0%~x0] ^: Error. Razer Synapse has not found in configured directories. Seems it's not installed. Script was interrupted
    goto :close
)
exit /b



:razer-shutdown
echo [93mRazer apps stopping . . .[0m

if "%~1"=="disable" (
    set option1=%~1
) else (
    set option1=
)

if "%synapse_version%"=="4" (
    rem from synapse4
    call :kill-process "RazerAppEngine.exe"
    call :kill-process "RzEngineMon.exe"
    call :kill-process "rzNotification.exe"
    call :kill-process "RzPowerTool.exe"
) else if "%synapse_version%"=="3" (
    rem from synapse3
    call :kill-process "Razer Synapse 3.exe"
    call :kill-process "RazerCentralService.exe"
    call :kill-process "Razer Synapse Service.exe"
    call :kill-process "GameManagerServiceStartup.exe"
    call :kill-process "GameManagerService.exe"
    call :kill-process "Razer Synapse Service Process.exe"
    call :kill-process "Razer Central.exe"
    call :kill-process "Razer Updater.exe"
) else (
    echo [:razer-shutdown] ^: Wrong 'synapse_version' param. error stopping razer. Script was interrupted
    goto :close
)

if "%fix_keyboard%"=="1" (set affect_services=1)
if "%affect_services%"=="1" (
    echo.
    echo [93mStopping services . . .[0m
    if "%synapse_version%"=="3" (
        call :service "RzActionSvc" "stop" %~1
        call :service "Razer Synapse Service" "stop" %~1
        call :service "Razer Game Manager Service" "stop" %~1

    ) else if "%synapse_version%"=="4" (
        call :service "Razer Chroma SDK Service" "stop" %~1
        call :service "Razer Chroma SDK Server" "stop" %~1
        call :service "Razer Chroma Stream Server" "stop" %~1
        call :service "Razer Game Manager Service 3" "stop" %~1
        call :service "Razer Elevation Service" "stop" %~1

    ) else (
        echo [:razer-shutdown] ^: Wrong 'synapse_version' param
    )
)
exit /b



:razer-wakeup
::services
if "%affect_services%"=="1" (
    echo [93mStarting Razer services . . .[0m
    if "%synapse_version%"=="3" (
        call :service "RzActionSvc" "start"
        call :service "Razer Synapse Service" "start"
        call :service "Razer Game Manager Service" "start"

    ) else if "%synapse_version%"=="4" (
        call :service "Razer Chroma SDK Service" "start"
        call :service "Razer Chroma SDK Server" "start"
        call :service "Razer Chroma Stream Server" "start"
        call :service "Razer Game Manager Service 3" "start"
        rem call :service "Razer Elevation Service" "start"

    ) else (
        msg * [%~n0%~x0] ^: Error. Missing Razer Synapse version. Script was interrupted
        goto :close
    )
)

echo.
echo [93mStarting Razer Synapse App . . .[0m

cd /d "!synapse!"
if "%synapse_version%"=="4" (
    start "" /min "RazerAppEngine.exe" --url-params=apps=synapse
) else if "%synapse_version%"=="3" (
    start "" /min "Razer Synapse 3.exe"
) else (
    echo Error starting the razer app. Script was interrupted
    goto :close
)


if "%silent%"=="1" (
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
exit /b



:reboot-keyboard
if "%fix_keyboard%"=="1" (
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
)
exit /b



:kill-process
if "%taskkill_force%"=="1" (
    :: forcing taskkill
    set tk-f=/f
) else (
    set tk-f=
)
set process=%~1
taskkill %tk-f% /t /im "%process%"
exit /b



:service
rem Examples
rem call :service "RzActionSvc" "stop" "disable"
rem call :service "RzActionSvc" "start"

set service=%~1

set option1=%~2
if "%option1%"=="stop" (
    set option2=%~3
    if "%option2%"=="disable" (
        echo.
        echo disabling start type of: '%service%' . . .
        powershell Set-Service -Name '%service%' -StartupType Disabled
    )
    echo.
    echo stopping: '%service%' . . .
    powershell Stop-Service -Name '%service%' -Force

) else if "%option1%"=="start" (
    echo.
    echo restoring start type of: '%service%' . . .
    powershell Set-Service -Name '%service%' -StartupType Automatic
    echo.
    echo starting: '%service%' . . .
    powershell Start-Service -Name '%service%'

) else (
    echo.
    echo [:service] ^: Error
    echo Args: 1:'%~1', 2:'%~2', 3:'%~3'
    exit /b 1
)
exit /b



:request-admin-rights
if "%debug%"=="1" (
    rem debug mode
    if "%require_admin%" == "1" (
        if "%adm_arg%" == "admin" (
            call :debug-warning
            echo [93m[powershell] : Restarted with admin rights
            echo By the way, window is kept awake, because we is in debug[0m
        ) else (
            echo [powershell] : Requesting admin rights . . .
            powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
            exit
        )
    ) else (
        call :debug-warning
    )
) else (
    rem if not debug mode
    if "%require_admin%" == "1" (
        if "%windowless%" == "1" (
            rem if we need to be quiet
            if "%hdn_arg%" == "hidden" (
                rem admin requested
            ) else (
                echo [powershell] : Requesting admin rights and trying to hide the window . . .
                powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin hidden\"' -Verb RunAs -WindowStyle Hidden"
                exit
            )
        ) else (
            rem if we don't need to be quiet
            if "%adm_arg%" == "admin" (
                rem admin requested
            ) else (
                echo [powershell] : Requesting admin rights . . .
                powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin hidden\"' -Verb RunAs"
                exit
            )
        )
    )
)
exit /b



:msg
msg * [%~n0%~x0] ^: %~1
exit /b



:debug-warning
echo.
echo [93m[warning] : Script is in debug mode^^![0m
if "%require_admin%" neq "1" (
    echo [91m
    set require_admin_msg1=Admin rights was not requested.
    set require_admin_msg2=We are not sure that we have admin rights. Otherwise it may cause any issues.
    echo [caution] :  !require_admin_msg1!
    echo [caution] : !require_admin_msg2![0m
)
if "%debug%" neq "1" (
    call :msg "!require_admin_msg1! !require_admin_msg2!"
)
echo.
exit /b



:ask-before
cls
setlocal EnableDelayedExpansion

echo [93mAre you sure you want to restart entire Razer Software?[0m

echo [93m
echo 1. Continue
echo 0. Cancel
echo [0m

choice /c 10 /n /m "[93m[ Confirm ]"[0m
if "%errorlevel%"=="1" cls&exit /b
if "%errorlevel%"=="2" (endlocal&exit)
pause&exit/b


