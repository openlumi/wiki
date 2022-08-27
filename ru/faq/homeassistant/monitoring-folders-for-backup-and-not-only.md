---

categories:
- use-cases
- monitoring

software:
- homeassistant
---
# Мониторинг папок для бэкапа и не только

С помощью интеграции [Folder Watcher](https://www.home-assistant.io/integrations/folder_watcher) можно мониторить файловую систему и следить за событием, такие как создание/удаление/изменение файлов в настроенных папках.


Интеграцию [Folder Watcher](https://www.home-assistant.io/integrations/folder_watcher) удобно использовать для мониторинга папки для бэкапов. Как сохранять бэкап на яндекс диске, читаем инструкцию [Подключаем Яндекс диск (Webdav)](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Подключаем-Яндекс-диск-(Webdav)).

1) В configuration.yaml добавим папку `/mnt` в список разрешенных внешних папок `allowlist_external_dirs:`

```
homeassistant:
  allowlist_external_dirs:
    - /mnt
```

2) Включим интеграцию `folder_watcher:` и укажем какую папку надо мониторить. Укажем путь к примонтированной папке `yandex_webdav`
> **Важно! Необходимо скопировать интеграцию `folder_watcher` в папку `components`. Читаем инструкцию [Как установить недостающий компонент для интеграции Home Assistant?](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Как-установить-недостающий-компонент-для-интеграции-Home-Assistant%3F)**

```
folder_watcher:
  - folder: /mnt/yandex_webdav/GatewayXiaomi/
    patterns:
      - '*.tar'
      - '*.zip'

sensor:
  - platform: folder
    folder: /mnt/yandex_webdav/GatewayXiaomi/
```

3) Создадим запуск скрипта `backup_gateway.sh` используя `shell_command`
> **Важно! Необходимо скопировать интеграцию `shell_command` в папку `components`. Читаем инструкцию [Как установить недостающий компонент для интеграции Home Assistant?](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Как-установить-недостающий-компонент-для-интеграции-Home-Assistant%3F)**

```
shell_command:
  backup_gateway: sh /etc/homeassistant/scripts/backup_gateway.sh
```

Содержимое скрипта
```
#!/bin/bash
backup="/mnt/yandex_webdav/Gateway/backup_gw-$(date +%Y-%m-%d_%H:%M).tar"

bkpfolder="
/etc/homeassistant
/etc/zigbee2mqtt
/etc/mosquitto
/root/.ssh
/mpd
"

bkpfile="
/etc/mpd.conf
#/etc/lumimqtt.json
/etc/mpd.state
"

echo "Starting a backup"
tar -cvf $backup $OF $bkpfolder $of $bkpfile&&
echo "The backup was completed successfully"

```


5) Перезагружаем Home Assistant

6) В Home Assistant появится сенсор папки `sensor.gatewayxiaomi`

Пример как это выглядит

```
path: /mnt/yandex_webdav/GatewayXiaomi/
filter: '*'
number_of_files: 1
bytes: 24441856
file_list:
  - /mnt/yandex_webdav/GatewayXiaomi/backup_gate_Xiaomi-2021-11-21_04:16.tar
unit_of_measurement: MB
friendly_name: GatewayXiaomi
icon: mdi:folder

```

7) В Home Assistant создаем скрипт на запуск бэкапа
```
alias: 'Система: Резервное копирование'
sequence:
  - service: shell_command.backup_gateway_xiaomi
mode: single
icon: mdi:database-sync
```


## Источники
* [Folder](https://www.home-assistant.io/integrations/folder/#configuration)
* [Folder Watcher](https://www.home-assistant.io/integrations/folder_watcher)
* [Allowlist external dirs](https://www.home-assistant.io/docs/configuration/basic/#allowlist_external_dirs)

