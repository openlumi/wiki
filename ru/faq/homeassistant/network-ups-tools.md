# Network UPS Tools. Мониторинг и управление ИБП

**Network UPS Tools** — это комплекс программ мониторинга и управления различными блоками бесперебойного питания.

Для мониторинга или управления ИБП необходимо ИБП подключить к ПК или к серверу, т.е подключить к чему либо, что будет выступать сервером для ИБП. У меня ИБП подключен к NAS Synology, а шлюз является клиентом. Шлюз благодаря интеграции **Network UPS Tools** получает данные от сервера сетевого ИБП, а благодаря пакету `NUT` посылает команды для управления ИБП.

> Важно! Ваш ИБП должен поддерживать Network UPS Tools. Список доступных ИБП можно посмотреть [здесь](https://networkupstools.org/stable-hcl.html) или на портале [Synology](https://www.synology.com/ru-ru/compatibility?search_by=category&category=upses&p=1&change_log_p=1)

## NAS Synology

**Включим сервер сетевого ИБП**
![image](https://user-images.githubusercontent.com/64090632/143942546-13de8eea-1bef-4f30-aab9-950708ce0a3b.png)
![image](https://user-images.githubusercontent.com/64090632/143942696-34b0db0e-e94b-4f5f-bf3d-d8a568e54fea.png)

**Указываем IP адреса, которым будет разрешен доступ к ИБП**
![image](https://user-images.githubusercontent.com/64090632/143942773-a5dc6c95-6a0e-4879-8821-0a1940f065c9.png)

***

**Добавим учетную запись в upsd.users для доступа к серверу сетевого ИБП**

Подключаемся к NAS Synology через консоль и открываем `upsd.users` расположенный `/usr/syno/etc/ups/upsd.users`
![image](https://user-images.githubusercontent.com/64090632/143943627-05bddef5-96ec-49f1-a3c3-ca7524ad036c.png)
![image](https://user-images.githubusercontent.com/64090632/143943576-3665d7c4-87f4-4d7b-b4d0-ad4248444763.png)

Добавим в самый низ строки c полным доступом и управлением(админские права) и укажем `upsmon slave` как дополнительное подключение, так как основное(master) подключение уже наcтроено по умолчанию.

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
> Важно! На вашем ИБП список команд может отличаться от предоставленного списка
> * [Cписок команд](https://networkupstools.org/docs/developer-guide.chunked/apas02.html)
> * [Общая информация по сенсорам и командам](https://networkupstools.org/docs/developer-guide.chunked/apas01.html)

* `load.off`                        - Turn off the load immediately
* `load.on`                         - Turn on the load immediately
* `load.off.delay`                  - Turn off the load possibly after a delay
* `load.on.delay`                   - Turn on the load possibly after a delay
* `shutdown.return`                 - Turn off the load possibly after a delay and return when power is back
* `shutdown.stayoff`                - Turn off the load possibly after a delay and remain off even if power returns
* `shutdown.stop`                   - Stop a shutdown in progress
* `shutdown.reboot`                 - Shut down the load briefly while rebooting the UPS
* `shutdown.reboot.graceful`        - After a delay, shut down the load briefly while rebooting the UPS
* `test.panel.start`                - Start testing the UPS panel
* `test.panel.stop`                 - Stop a UPS panel test
* `test.failure.start`              - Start a simulated power failure
* `test.failure.stop`               - Stop simulating a power failure
* `test.battery.start`              - Start a battery test
* `test.battery.start.quick`        - Start a "quick" battery test
* `test.battery.start.deep`         - Start a "deep" battery test
* `test.battery.stop`               - Stop the battery test
* `calibrate.start`                 - Start runtime calibration
* `calibrate.stop`                  - Stop runtime calibration
* `beeper.disable`                  - Disable UPS beeper/buzzer
* `beeper.enable`                   - Enable UPS beeper/buzzer
* `beeper.mute`                     - Temporarily mute UPS beeper/buzzer
* `beeper.off`                      - Turn off UPS beeper/buzzer
* `beeper.on`                       - Turn on UPS beeper/buzzer
* `bypass.start`                    - Put the UPS in bypass mode
* `bypass.stop`                     - Take the UPS out of bypass mode

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

> Важно! 
> * В OS Home Assistant отсутствует пакет NUT. Как его установить, читайте в самом низу
> * Более подробно про установку недостающего компонента читаем [здесь](https://github.com/DivanX10/wiki/blob/gh-pages/ru/faq/homeassistant/how-do-i-install-the-missing-component-for-homeassistant-integration.md#как-установить-недостающий-компонент-для-интеграции-home-assistant)

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

```
pip install pynut2==2.1.2
```
![image](https://user-images.githubusercontent.com/64090632/143948890-94debf8f-6569-4d5b-a508-9645a81d612c.png)
![image](https://user-images.githubusercontent.com/64090632/143948945-88a65292-e567-4a56-887d-daf4cd54d3a2.png)

**4)** Перезагружаем шлюз, можно конечно перезагрузить Home Assistant, но я все же перезагружаю шлюз целиком, так точно интеграция прогружается в Home Assistant
```
reboot
```
**5)** Ставим интеграцию **Network UPS Tools** и указываем IP адрес к серверу ИБП. Логин и пароль можно не указывать и без него пускает, если не пустит, то указывайте ту УЗ, которую прописали в `upsd.users` 

![Безымянный-1](https://user-images.githubusercontent.com/64090632/143950494-c7ee31b5-17c2-4313-a976-17c91b813876.jpg)

***

## Создадим выключатели

![image](https://user-images.githubusercontent.com/64090632/143951843-843b302b-2539-42b5-a44d-739b603b405b.png)

Для выключателей будем использовать платформу [Command line Switch](https://www.home-assistant.io/integrations/switch.command_line/). 
> Важно! Ниже полностью рабочий пример + я использовал условие **последнее состояние** второго выключателя, они как бы в перекрестных линиях находятся, т.е условие для выключателя **Полный тест батареи** смотрит на выключатель **Быстрый тест батареи**, а условие для выключателя **Быстрый тест батареи** смотрит на выключатель **Полный тест батареи**. **Зачем я так сделал?** все дело в том, что статус **ups.status** один и он применим как для быстрого теста, так и для долго теста батареи и когда включаем тест батареи и не важно какой вариант, то оба выключателя будут включены, а с условием последнее состояние будет включен только тот выключатель, который мы включили. Таже строка **command_timeout** будет опрашивать статус и выставлять выключателю реальный статус

```
switch: 
- platform: command_line
  switches:
    ups_beeper: 
      command_on: upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 beeper.enable
      command_off: upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 beeper.disable
      command_state: upsc ups@192.168.1.200 ups.beeper.status
      command_timeout: 15
      value_template: '{{ is_state("sensor.ups_beeper_status","enabled") }}'
      friendly_name: 'Звуковое оповещение'

    ups_test_battery_deep:
      command_on: upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 test.battery.start.deep
      command_off: upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 test.battery.stop
      command_state: upsc ups@192.168.1.200 ups.status
      command_timeout: 15
      friendly_name: 'Полный тест батареи'
      value_template: >
        {% set test_result = is_state("sensor.ups_self_test_result","In progress") %}
        {% set test_battery_quick = is_state("switch.ups_test_battery_quick", "off") and (now() - states.switch.ups_test_battery_quick.last_changed).seconds > 120 %}
        {% if test_result and test_battery_quick %} True
        {% else %} False
        {% endif %}

    ups_test_battery_quick:
      command_on: upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 test.battery.start.quick
      command_off: upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 test.battery.stop
      command_state: upsc ups@192.168.1.200 ups.status
      friendly_name: 'Быстрый тест батареи'
      command_timeout: 15
      value_template: >
        {% set test_result = is_state("sensor.ups_self_test_result","In progress") %}
        {% set test_battery_deep = is_state("switch.ups_test_battery_deep", "off") and (now() - states.switch.ups_test_battery_deep.last_changed).seconds > 120 %}
        {% if test_result and test_battery_deep %} True
        {% else %} False
        {% endif %}
```

## Создадим сенсоры

> Важно! Данные сенсоры как дополнение и не являются обязательным. 

* Первый сенсор **UPS Load Watts** показывает нагрузку в ваттах, вместо %
* Второй сенсор создал с аттрибутом уровня заряда батареи, чтобы вывести в карточке как аттрибут, используя пользовательскую интеграцию [Home Assistant. Multiple Entity Row](https://github.com/benct/lovelace-multiple-entity-row)

Для понимания о каком аттрибуте идет речь
```
  - type: custom:fold-entity-row
    head:
      entity: sensor.ups_cyberpower_livingroom
      name: ИБП
      type: custom:multiple-entity-row
      secondary_info:
        attribute: Уровень заряда
        name: Батарея
        unit: '%'
```

Сами сенсоры
```
sensor:
  - platform: template
    sensors:
      ups_load_watts:
        friendly_name: UPS Load Watts
        unit_of_measurement: "W"
        value_template: "{{ states('sensor.ups_load') | float(default=0) / 100 * 720 | round(0) }}"

  - platform: template
    sensors:
      ups_cyberpower_livingroom:
        friendly_name: 'Гостиная: ИБП'
        icon_template: mdi:battery
        value_template: "{{ states('sensor.ups_status') }}"
        attribute_templates:
          Уровень заряда: "{{ states('sensor.ups_battery_charge') }}"
```

## Создадим групу сенсоров

Это группа сенсоров будет применяться в карточке для ИБП, где достаточно тапнуть на иконку сенсоры и будет отображаться список сеноров ИБП, что очень удобно.

```
livingroom_ups:
  name: "Гостиная: ИБП. Сенсоры"
  icon: mdi:battery
  all: false
  entities:
    - sensor.ups_battery_charge
    - sensor.ups_status
    - sensor.ups_beeper_status
    - sensor.ups_load
    - sensor.ups_load_watts
    - sensor.ups_nominal_real_power
    - sensor.ups_low_battery_setpoint
    - sensor.ups_warning_battery_setpoint
    - sensor.ups_input_voltage
    - sensor.ups_output_voltage
    - sensor.ups_low_voltage_transfer
    - sensor.ups_high_voltage_transfer
    - sensor.ups_battery_voltage
    - sensor.ups_nominal_battery_voltage
    - sensor.ups_nominal_input_voltage
    - sensor.ups_ups_shutdown_delay
    - sensor.ups_load_restart_delay
    - sensor.ups_battery_runtime
    - sensor.ups_self_test_result
    - sensor.ups_low_battery_runtime
    - sensor.ups_load_start_timer
    - sensor.ups_load_shutdown_timer
    - sensor.ups_battery_chemistry
    - sensor.ups_status_data
    - sensor.ups_battery_manuf_date
```


После создания выключателей и сенсоров, запускаем в Home Assistant проверку конфигурации и если все верно, перезагружаем Home Assistant

***
## Добавим карточку в Lovelace

Данную карточку для ИБП я создал с использованием нескольких пользовательских интеграции
* [Home Assistant. Multiple Entity Row](https://github.com/benct/lovelace-multiple-entity-row)
* [Home Assistant. Fold Entity Row](https://github.com/thomasloven/lovelace-fold-entity-row)
* [Home Assistant. Group](https://www.home-assistant.io/integrations/group/)


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

## Как запустить в OS Home Assistant клиент NUT

Если попытаетесь в **OS Home Assistant**, через **SSH** запустить `upsc ups@192.168.1.200`, то получите подобное сообщение, что такой команды нет

![image](https://user-images.githubusercontent.com/64090632/143955324-e4043897-5ee1-47ac-80e4-7dee64431a58.png)

При попытке установить пакет nut `apk add nut` получите сообщение, что такого пакета нет

![image](https://user-images.githubusercontent.com/64090632/143955987-4ec08401-2079-46c4-8282-6fa1fac99288.png)


Для того, чтобы установить клиента nut, необходимо открыть `repositories` по пути `/etc/apk/repositories` и добавить ссылки на тестовые и крайние репозитории

![image](https://user-images.githubusercontent.com/64090632/143956240-ede2dba3-6531-4e12-9530-a38fb489df4c.png)
![image](https://user-images.githubusercontent.com/64090632/143956456-f0125031-6d68-4fc4-a4c7-ca0b4f748a9e.png)


```
http://nl.alpinelinux.org/alpine/edge/main
http://nl.alpinelinux.org/alpine/edge/community
http://nl.alpinelinux.org/alpine/edge/testing
```

После того как добавили ссылки, можно теперь установить пакет **NUT** командой `apk add nut` 

![image](https://user-images.githubusercontent.com/64090632/143956787-ab6ea78c-4088-45d8-9792-2613b9922b3c.png)


> Важно! Если вы перезагрузите машину полностью, то OS Home Assistant затрет все настройки и пакеты, и придется по новой выполнять процедуру. Проблему можно решить запуском скрипта, но на данный момент есть проблема с запуском скрипта из Home Assistant с помощью shell command. Запущенный скрипт из Home Assistant не отрабатывает команду. Скрипт можно запустить с SSH. Будет здорово, если вы знаете как правильно запускать скрипт с Home Assistant и напишите мне в телегу [SmartHomeDivan](https://t.me/smart_home_divan)

Создадим скрипт который будет добавлять ссылки и устанавливать пакет `nut` и пусть скрипт лежит в папке `/config/scripts`

**1)** Созадим папку `scripts` в папке `config`
```
mkdir /config/scripts
```
**2)** Создадим файлик и именуем `install_nut.sh`
```
touch /config/scripts/install_nut.sh
```

**3)** Откроем файлик `install_nut.sh`
```
nano /config/scripts/install_nut.sh
```

**4)** Добавим в файлик следующее

```
#!/bin/bash
cat <<_EOF_ >> /etc/apk/repositories
https://dl-cdn.alpinelinux.org/alpine/v3.14/main
https://dl-cdn.alpinelinux.org/alpine/v3.14/community
http://nl.alpinelinux.org/alpine/edge/main
http://nl.alpinelinux.org/alpine/edge/community
http://nl.alpinelinux.org/alpine/edge/testing
_EOF_

sleep 2
apk add nut
echo "Done"
sleep 2
exit
```

**5)** Запуск скрипта 
```
sh /config/scripts/install_nut.sh
```

Для запуска скрипта из Home Assistant нужно использовать shell command. Ниже пример конфига для запуска скрипта из Home Assistant

```
shell_command:
  install_nut: sh /config/scripts/install_nut.sh
```




## Источники
* [Network UPS Tools](https://networkupstools.org)
* [Network UPS Tools Developer Guide](https://networkupstools.org/docs/developer-guide.chunked/index.html)
* [Home Assistant. Network UPS Tools](https://www.home-assistant.io/integrations/nut/)
* [Home Assistant. Command line Switch](https://www.home-assistant.io/integrations/switch.command_line/)
* [Home Assistant. Multiple Entity Row](https://github.com/benct/lovelace-multiple-entity-row)
* [Home Assistant. Fold Entity Row](https://github.com/thomasloven/lovelace-fold-entity-row)
* [Home Assistant. Group](https://www.home-assistant.io/integrations/group/)
