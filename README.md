# RazerSynapse-batch-tools
My "Razer Synapse 3" batchfix

`razer-restart.bat` - Перезапустить "Razer Synapse 3" и переподключить клавиатуру (тут надо много описать, позже будет инструкция)
`razer-disable.bat` - Полностью остановить Razer Synapse 3 
`razer-start.bat` - Запустить Razer Synapse

# razer-restart.bat
Перед запуском этого файла требуется проверить настройки внутри файла

>[!tip]
> - Чтобы скачать файлы: [Ищем такую кнопку](https://github.com/user-attachments/assets/c0169211-4266-4d54-b594-22e762d0938b). А за подробностями [Сюда](https://docs.github.com/ru/get-started/start-your-journey/downloading-files-from-github) или [Сюда](https://blog.skillfactory.ru/kak-skachivat-s-github/)
> - Для редактирования скачанного на вашем ПК файла: **`ПКМ` -> `Изменить`**

Пример пути для **Razer Synapse 3**
```bat
:: synapse path
set synapse=C:\Program Files (x86)\Razer\Synapse3\WPFUI\Framework\Razer Synapse 3 Host
```

Также есть параметр для перезапуска вашей клавиатуры с использованием утилиты **`USBDeview.exe`**:
```bat
::keyboard fix
set fix_keyboard=1
```

Вот фрагмент кода отвечающего за перезапуск клавиатуры
```bat
if %fix_keyboard%==1 (
:reboot-hid-keyboard
cls
cd /d "%~dp0"
:: This usb names are unique please check your keyboard in bin/USBDeview.exe
echo ! Restart keyboard
start "bin/" "bin/USBDeview.exe" /RunAsAdmin /disable_enable "USB\VID_1532&PID_024E&MI_02\6&3860e76&0&0002"
>nul timeout /t 3 /nobreak
start "bin/" "bin/USBDeview.exe" /RunAsAdmin /disable_enable "USB\VID_1532&PID_024E&MI_01\6&3860e76&0&0001"
>nul timeout /t 3 /nobreak
echo ! Restarted
)
```
- `"USB\VID_1532&PID_024E&MI_02\6&3860e76&0&0002"` и `"USB\VID_1532&PID_024E&MI_01\6&3860e76&0&0001"` мои названия устройства, вам же нужны свои. 
Для этого можно воспользоваться `bin/USBDeview.exe`. В нём вы и сможете определить вашу клавиатуру и подставить нужное имя устройства.
- Как вариант, в **USBDeview** можно создать ярлыки к вашим устройствам и из их свойств сделать подстановку: 
1. ПКМ > "Create Desktop Shortcut" > "Diable+Enable Device"
2. Заходим в свойства, созданных вами ярлыков устройств, (ПКМ > Свойства) и из строки "Объект" копируем в конце название вашего устройства.
3. Подставляем их в **`razer-restart.bat`** аналогичным образом как в моём примере и проверяем эффект.