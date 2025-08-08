# razer-batch-tools
Мои пакетные скрипты для Razer Synapse 3 & 4 

>[!tip]
> - Cкачать репозиторий: [Download ZIP](https://github.com/N3M1X10/RazerSynapse-batch-tools/archive/refs/heads/master.zip)
> - Для редактирования скачанных на вашем ПК `.bat`-файлов: **`ПКМ` -> `Изменить`**


### 📁Файлы
- `disable-razer.bat` - Полностью остановить и заморозить службы Razer
- `restart-razer.bat` - Перезапустить "Razer Synapse" и переподключить клавиатуру

>[!warning]
> Пожалуйста, перед запуском скриптов из репозитория: убедитесь что ваши данные в приложениях Razer - сохранены


# `restart-razer.bat`

>[!important]
>Перед запуском этого файла - требуется проверить настройки внутри файла


## ⚙️Настройки

- Убедитесь что путь соответствует истине в вашей системе!

>[!note]
>Пример пути для **Synapse 3**:
>```bat
>:: razer synapse3 working directory path
>set synapse3=C:\Program Files (x86)\Razer\Synapse3\WPFUI\Framework\Razer Synapse 3 Host
>```
>
>Пример пути для **Synapse 4**:
>```bat
>:: razer synapse4 working directory path
>set synapse4=C:\Program Files\Razer\RazerAppEngine
>```



- Остальные параметры, с их описанием - есть внутри файла


## 💢Исправление ошибки "Невидимая клавиатура"
А давайте поможем ~~Дашеньке~~ Synapse найти вашу клавиатуру

>[!note]
>- Параметр отвечающий за перезапуск вашей клавиатуры:
>```bat
>:: if "1" the script will try to restart your keyboard. 
>:: Please, provide your keyboard name below
>:: with this option SERVICES WILL BE RESTARTED anyway
>:: default: '1'
>set fix_keyboard=1
>
>```
>
> - Этот параметр, при перезапуске Synapse попытается перезапустить (переподключить) вашу клавиатуру и исправить ошибку "Невидимой клавиатуры"

>[!important]
>**Обязательно укажите своё название клавиатуры !!!**
> - Пример:
>```bat
>:: Set YOUR 'friendly' keyboard name
>set keyboard_name=Razer BlackWidow V3
>```
> - Посмотреть название устройств можно так: 
>   - `Win+X` > "Диспетчер устройств" > "Клавиатуры" > Ищем свою клавиатуру > Вкладка: "Сведения" > В выпадающем меню: "Описание устройства" > Копируем значение


### Почему просто не перезапустить все устройства класса "Keyboard" ?
У клавиатуры Razer, помимо "Keyboard" есть ещё два класса "Mouse" и "HIDClass", что делает вариант с указанием конкретного названия клавиатуры - оптимальным

