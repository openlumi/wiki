# Установил zigbee2mqtt. Не работает веб страница zigbee2mqtt


## Если установили zigbee2mqtt и веб страница zigbee2mqtt не открывается, то возможно проблема в следующем

* Не запущена служба zigbee2mqtt. Надо запустить службу, либо через консоль командой /etc/init.d/zigbee2mqtt/start, либо через LuCI System => Startup

* Прошивка с baudrate 115200, а в конфигурации zigbee2mqtt указан baudrate 1000000, необходимо в конфигурации zigbee2mqtt указать верный baudrate и перезапустить службу zigbee2mqtt

Просмотреть полный список команд /etc/init.d/zigbee2mqtt

Стандартный конфиг для zigbee2mqtt, только смотрим на строку `baudrate:`. Если вы прошивали свой модуль zigbee прошивкой с baudrate 115200, то указываем `baudrate:115200`, а если прошивали прошивкой baudrate 1000000, то указываем `baudrate:1000000 `
```
homeassistant: true
permit_join: false
mqtt:
  base_topic: zigbee2mqtt
  server: mqtt://localhost
serial:
  port: /dev/ttymxc1
  adapter: zigate
advanced:
  baudrate: 1000000
  log_level: info
  log_directory: /tmp/log/zigbee2mqtt/%TIMESTAMP%
  log_file: log.txt
  log_rotation: true
  log_output:
    - file
  homeassistant_legacy_entity_attributes: false
  legacy_api: false
devices: devices.yaml
groups: groups.yaml
frontend:
  port: 8090
experimental:
  new_api: true
device_options:
  legacy: false

```
