# Альтернатива HACS. Загружаем или обновляем интеграции автоматически

[Стартовая страница WiKi](https://github.com/DivanX10/wiki#readme)

Это легкая альтернатива HACS и данная интеграция [Updater](https://github.com/AlexxIT/Updater) позволит загрузить необходимую интеграцию или обновить установленную интеграцию, которые указаны в файлике `updater.txt`

![Integration version](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/blob/main/image/integration_version.JPG)


1) Создаем в `configuration.yaml` или, если у вас настроен packages, то просто закидываем в packages. Про удобную конфигурацию читаем [здесь](https://sprut.ai/client/blog/3180)

```
switch:
  - platform: command_line
    switches:
      updater:
        friendly_name: Update integration
        command_on: python /etc/homeassistant/updater.py update
        command_off: python /etc/homeassistant/updater.py
        command_state: |
          python -B -c "exec('''try: import updater\nexcept ModuleNotFoundError: from urllib.request import urlretrieve; urlretrieve('https://raw.github.com/AlexxIT/Updater/master/updater.py', '/etc/homeassistant/updater.py'); import updater'''); updater.run(interval=3600)"
        command_timeout: 1800
```

2) Файлик `updater.txt` создать вручную и закинуть в `/etc/homeassistant/`
3) В файлик добавляем ссылки на интеграции, которые желаем загрузить в папку `custom_components` или обновить установленные интеграции в папке `custom_components`. Добавляем ссылки с github на нужные нам интеграции, которые будут скачаны и загружены в папку `custom_components` или обновлены до последней версии

Пример файлика `updater.txt`
```
https://github.com/AlexxIT/YandexStation
https://github.com/dmitry-k/yandex_smart_home
https://github.com/dext0r/ha-yandex-station-intents
https://github.com/custom-components/ble_monitor
```

4) Перезагружаем Home Assistant
5) Выводим в lovelace выключатель и включаем его
6) Если все сделано правильно, то в папке `custom_components` должны появиться интеграции, которые мы указали в файлике `updater.txt` и в `/etc/homeassistant/` появятся два файлика + созданный нами файлик `updater.txt`. В итоге должно быть 3 файлика
> * updater.json
> * updater.py
> * updater.txt

***


## Сенсор

При желании можно вывести сенсор установленной версии пользовательской интеграции. Для этого мы будем использовать интеграцию [File](https://www.home-assistant.io/integrations/file/). Для работы нам необходимо добавить внешний путь `/etc/homeassistant/` в исключение

В `configuration.yaml` добавляем строку
```
homeassistant:
  allowlist_external_dirs:
    - /etc/homeassistant
```

Cоздаем сенсор для каждой интеграции, который, либо прописываем в `configuration.yaml`, либо закидываем в packages. Сенсор будет считывать с файлика `version.txt` версию интеграции, который создает интеграция [Updater for Home Assistant](https://github.com/AlexxIT/Updater) при запуске. Важно указывать полный путь к файлику `version.txt`.

> **Важно! Указывать нужно путь к установленным интеграциям и в папке с интеграции должен быть файлик `version.txt`, создаем его сами и он может быть совершенно пустым. Но если этого не сделать, то при проверке конфигурации в Home Assistant получим такую ошибку**

> Invalid config for [sensor.file]: not a file for dictionary value @ data['file_path']. Got '/etc/homeassistant/custom_components/yandex_smart_home/version.txt'. (See ?, line ?).


**Пример сенсора для интеграции [Yandex Station](https://github.com/AlexxIT/YandexStation)**
```
sensor:
  - name: "Integration Yandex Station" 
    platform: file
    file_path: /etc/homeassistant/custom_components/yandex_station/version.txt
```

**Пример сенсора для интеграции [Yandex Smart Home](https://github.com/dmitry-k/yandex_smart_home)**
```
sensor:
  - name: "Integration Yandex Smart Home"
    platform: file
    file_path: /etc/homeassistant/custom_components/yandex_smart_home/version.txt
```

**Пример сенсора для интеграции [Yandex Station Intents](https://github.com/dext0r/ha-yandex-station-intents)**
```
sensor:
  - name: "Integration Yandex Station Intents"
    platform: file
    file_path: /etc/homeassistant/custom_components/yandex_station_intents/version.txt
```

**Пример сенсора для интеграции [Passive BLE Monitor](https://github.com/custom-components/ble_monitor)**
```
sensor:
  - name: "Integration Passive BLE Monitor"
    platform: file
    file_path: /etc/homeassistant/custom_components/ble_monitor/version.txt
```

Я создал один файлик `updating_custom_components.yaml` и добавил в него выключатель для загрузки\обновления интеграции и сенсоры
```
switch:
  - platform: command_line
    switches:
      updater:
        friendly_name: Updater
        command_on: python /etc/homeassistant/updater.py update  # run updates process
        command_off: python /etc/homeassistant/updater.py # force reload witout timeout
        command_state: |
          python -B -c "exec('''try: import updater\nexcept ModuleNotFoundError: from urllib.request import urlretrieve; urlretrieve('https://raw.github.com/AlexxIT/Updater/master/updater.py', '/etc/homeassistant/updater.py'); import updater'''); updater.run(interval=3600)"
        command_timeout: 1800  # this is timeout, not update interval!


sensor:
  - name: "Integration Yandex Station" 
    platform: file
    file_path: /etc/homeassistant/custom_components/yandex_station/version.txt

  - name: "Integration Yandex Smart Home"
    platform: file
    file_path: /etc/homeassistant/custom_components/yandex_smart_home/version.txt

  - name: "Integration Yandex Station Intents"
    platform: file
    file_path: /etc/homeassistant/custom_components/yandex_station_intents/version.txt

  - name: "Integration Passive BLE Monitor"
    platform: file
    file_path: /etc/homeassistant/custom_components/ble_monitor/version.txt

```



## Источники
* [Интеграция Updater](https://github.com/AlexxIT/Updater)
* [Интеграция Yandex Smart Home](https://github.com/dmitry-k/yandex_smart_home)
* [Интеграция Yandex Station Intents](https://github.com/dext0r/ha-yandex-station-intents)
* [Удобная настройка (конфигурация) Home Assistant](https://sprut.ai/client/blog/3180)
* [Интеграция File](https://www.home-assistant.io/integrations/file/)
* [Command line Sensor](https://www.home-assistant.io/integrations/sensor.command_line/#usage-of-json-attributes-in-command-output)
* [Allowlist external dirs](https://www.home-assistant.io/docs/configuration/basic/#allowlist_external_urls)