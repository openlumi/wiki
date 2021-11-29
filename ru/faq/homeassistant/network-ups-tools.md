# Network UPS Tools. Мониторинг и управление ИБП

**Network UPS Tools** — это комплекс программ мониторинга и управления различными блоками бесперебойного питания.

Для мониторинга или управления ИБП, необходимо ИБП подключить к ПК или к серверу, т.е подключить к чему либо, что будет выступать сервером для ИБП. У меня ИБП подключен к NAS Synology, а шлюз  и я покажу пример настройки как это настраивается.

> Важно! Ваш ИБП должен поддерживать Network UPS Tools. Список доступных ИБП можно посмотреть [здесь](https://networkupstools.org/stable-hcl.html) или на портале [Synology](https://www.synology.com/ru-ru/compatibility?search_by=category&category=upses&p=1&change_log_p=1)

## NAS Synology

**Включим сервер сетевого ИБП**
![image](https://user-images.githubusercontent.com/64090632/143942546-13de8eea-1bef-4f30-aab9-950708ce0a3b.png)
![image](https://user-images.githubusercontent.com/64090632/143942696-34b0db0e-e94b-4f5f-bf3d-d8a568e54fea.png)

**Указываем IP адреса, которым будет разрешен доступ к ИБП**
![image](https://user-images.githubusercontent.com/64090632/143942773-a5dc6c95-6a0e-4879-8821-0a1940f065c9.png)

***

**Добавим учетную запись для доступа к серверу сетевого ИБП в upsd.users**
Подключаемся к NAS Synology через консоль и  открываем upsd.users расположенный /usr/syno/etc/ups/upsd.users
![image](https://user-images.githubusercontent.com/64090632/143943627-05bddef5-96ec-49f1-a3c3-ca7524ad036c.png)
![image](https://user-images.githubusercontent.com/64090632/143943576-3665d7c4-87f4-4d7b-b4d0-ad4248444763.png)

Добавим в самый низ строки c полным доступом и управлением(админские права) и укажем **upsmon slave** как дополнительное подключение, та как основное(master) подключение уже наcтроено по умолчанию

```
[hassmon]
  password = 12345678
  actions = set
  actions = fsd
  instcmds = all
  upsmon slave
```

***

**Перезапустим службу сервера сетевого ИБП**

Просто снимите галочку и нажмите применить, а после поставьте галочку и еще раз применить. На этом все. Осталось проверить доступ с консоли на шлюзе.
![image](https://user-images.githubusercontent.com/64090632/143944159-6461389b-e165-408c-a8ee-00ae65992037.png)

***

**На шлюзе ставим пакеты через LuCI**
* nut
* nut-upsc
* nut-upscmd

![image](https://user-images.githubusercontent.com/64090632/143945211-fba5266f-6676-4150-b2b3-28e3459ac76b.png)

***

Вводим команду для подключения к NAS Synology `upsc ups@ip`. Если доступ есть, то вы получите информацию с ИБП
![image](https://user-images.githubusercontent.com/64090632/143944340-08b5fadc-af45-4820-86b7-48f88c196137.png)



## Команды для управления ИБП
> Важно! На вашем ИБП список команд может отличаться от данного [списка](https://networkupstools.org/docs/developer-guide.chunked/apas02.html).

* `load.off`                        - (Turn off the load immediately)
* `load.on`                         - (Turn on the load immediately)
* `load.off.delay`                  - (Turn off the load possibly after a delay)
* `load.on.delay`                   - (Turn on the load possibly after a delay)
* `shutdown.return`                 - (Turn off the load possibly after a delay and return when power is back)
* `shutdown.stayoff`                - (Turn off the load possibly after a delay and remain off even if power returns)
* `shutdown.stop`                   - (Stop a shutdown in progress)
* `shutdown.reboot`                 - (Shut down the load briefly while rebooting the UPS)
* `shutdown.reboot.graceful`        - (After a delay, shut down the load briefly while rebooting the UPS)
* `test.panel.start`                - (Start testing the UPS panel)
* `test.panel.stop`                 - (Stop a UPS panel test)
* `test.failure.start`              - (Start a simulated power failure)
* `test.failure.stop`               - (Stop simulating a power failure)
* `test.battery.start`              - (Start a battery test)
* `test.battery.start.quick`        - (Start a "quick" battery test)
* `test.battery.start.deep`         - (Start a "deep" battery test)
* `test.battery.stop`               - (Stop the battery test)
* `calibrate.start`                 - (Запуск калибровки)
* `calibrate.stop`                  - (Остановка калибровки)
* `beeper.disable`                  - (Выключение звукового сигнала)
* `beeper.enable`                   - (Включение звукового сигнала)
* `beeper.mute`                     - (Звуковой сигнал отключен)
* `beeper.off`                      - (Выключение звукового сигнала)
* `beeper.on`                       - (Включение звукового сигнала)
* `bypass.start`
* `bypass.stop`

***

**Примеры для управления ИБП**

Включить звуковое оповещение. Если успех, то получим статус `OK`
```
upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 beeper.enable
```
Выключить звуковое оповещение. Если успех, то получим статус `OK`
```
upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 beeper.disable
```

Проверить статус звукового сигнала
```
upsc ups@192.168.1.200 ups.beeper.status
```
![image](https://user-images.githubusercontent.com/64090632/143947002-dcc24a04-67e1-42f8-99d1-cd949f05490e.png)



***
## Установим интеграцию Network UPS Tools в Home Assistant

> Важно! Более подробно про установку недостающего компонента читаем [здесь](https://github.com/DivanX10/wiki/blob/gh-pages/ru/faq/homeassistant/how-do-i-install-the-missing-component-for-homeassistant-integration.md#как-установить-недостающий-компонент-для-интеграции-home-assistant)

**1)** Раскомментируем строку NUT в `config_flows.py`, который находится по пути 
```
/usr/lib/python3.9/site-packages/homeassistant-XXXX.XX.X-py3.9.egg/homeassistant/generated
```

![image](https://user-images.githubusercontent.com/64090632/143947920-8abf5a9d-676e-43ac-9109-acddf1045c1b.png)

**2)** Скопируем папку c интеграцией nut из [архива](https://github.com/home-assistant/core/tags) в `components` , которая находится по пути 
```
/usr/lib/python3.9/site-packages/homeassistant-2021.11.5-py3.9.egg/homeassistant/components
```

**3)** Установим требуемый пакет согласно файлу `manifest.json`

![image](https://user-images.githubusercontent.com/64090632/143948890-94debf8f-6569-4d5b-a508-9645a81d612c.png)
![image](https://user-images.githubusercontent.com/64090632/143948945-88a65292-e567-4a56-887d-daf4cd54d3a2.png)

**4)** Перезагружаем шлюз, можно конечно перезагрузить Home Assistant, но я все же перезагружаю шлюз целиком, так точно интеграция прогружается в Home Assistant
```
reboot
```
**5)** Ставим интеграцию **Network UPS Tools** и указываем IP адрес к серверу ИБП. Логин и пароль можно не указывать и без него пускает, елси не пустит, то указывайте ту УЗ, которую прописали в `upsd.users` 

![Безымянный-1](https://user-images.githubusercontent.com/64090632/143950494-c7ee31b5-17c2-4313-a976-17c91b813876.jpg)



***
## Панель управления
Данную карточку для ИБП я создал с использованием двух пользовательских интеграции
* [multiple entity row](https://github.com/benct/lovelace-multiple-entity-row)
* [fold entity row](https://github.com/thomasloven/lovelace-fold-entity-row)


![image](https://user-images.githubusercontent.com/64090632/143938920-71b7df88-6f34-46a8-b82b-7cf7966b98ae.png)

```
type: entities
entities:
  - type: custom:fold-entity-row
    head:
      entity: sensor.ups_cyberpower_livingroom
      name: ИБП
      type: custom:multiple-entity-row
      secondary_info:
        attribute: Уровень заряда
        name: Батарея
        unit: '%'
      state_header: Статус
      entities:
        - entity: group.livingroom_ups
          name: Сенсоры
          icon: mdi:information-outline
        - entity: sensor.ups_load
          name: Нагрузка
        - entity: sensor.ups_load_watts
          name: Нагрузка
    entities:
      - entity: switch.ups_beeper
        secondary_info: last-changed
        icon: mdi:volume-high
      - entity: switch.ups_test_battery_quick
        secondary_info: last-changed
        icon: mdi:battery
      - entity: switch.ups_test_battery_deep
        secondary_info: last-changed
        icon: mdi:battery

```




## Источники
* [Network UPS Tools](https://networkupstools.org)
* [Network UPS Tools Developer Guide](https://networkupstools.org/docs/developer-guide.chunked/index.html)
* [Home Assistant. Network UPS Tools](https://www.home-assistant.io/integrations/nut/)
* [Home Assistant. Command line Switch](https://www.home-assistant.io/integrations/switch.command_line/)
* [Home Assistant. multiple entity row](https://github.com/benct/lovelace-multiple-entity-row)
* [Home Assistant. fold entity row](https://github.com/thomasloven/lovelace-fold-entity-row)
* [Home Assistant. Group](https://www.home-assistant.io/integrations/group/)
