---

categories:
- use-cases
- monitoring

software:
- homeassistant
---
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
  password = 12345678        # Указываем любой пароль
  actions = set              # Разрешаем менять параметры ИБП
  actions = fsd              # Разрешаем включать Forced Shotdown
  instcmds = all             # Разрешаем отправлять команды для управления ИБП
  upsmon slave               # Включаем дополнительное подключение
```


***

**Перезапустим службу сервера сетевого ИБП**

* **Вариант 1**: Запускаем команду через консоль для перезапуска службы Network UPS Tools

```
synoservice --restart ups-usb
```

* **Вариант 2**: Просто снимите галочку и нажмите применить, а после поставьте галочку и еще раз применить. На этом все. Осталось проверить доступ с консоли на шлюзе.

![image](https://user-images.githubusercontent.com/64090632/143944159-6461389b-e165-408c-a8ee-00ae65992037.png)


***

**На шлюзе ставим пакеты через LuCI**
* nut
* nut-upsc
* nut-upscmd

![image](https://user-images.githubusercontent.com/64090632/143945211-fba5266f-6676-4150-b2b3-28e3459ac76b.png)

***

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

![image](https://user-images.githubusercontent.com/64090632/143947002-dcc24a04-67e1-42f8-99d1-cd949f05490e.png)

Вывести список сенсоров ИБП
```
upsc ups@192.168.1.200
```

Вывести список поддерживаемых команд ИБП
```
upscmd -l ups@192.168.1.200:3493
```

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

Выключить ИБП. Выключенный ИБП не включится после подачи питания
```
upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 load.off
```

Выключить ИБП. Выключенный ИБП не включится после подачи питания
```
upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 shutdown.stayoff
```

Выключить ИБП. Выключенный ИБП включится после подачи питания
```
upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 shutdown.return
```



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
/usr/lib/python3.9/site-packages/homeassistant-XXXX.XX.X-py3.9.egg/homeassistant/components
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
> Важно! Ниже полностью рабочий пример + я использовал условие **последнее состояние** второго выключателя, они как бы в перекрестных линиях находятся, т.е условие для выключателя **Полный тест батареи** смотрит на выключатель **Быстрый тест батареи**, а условие для выключателя **Быстрый тест батареи** смотрит на выключатель **Полный тест батареи**.
> **Зачем я так сделал?** Все дело в том, что статус **ups.status** один и он применим как для быстрого теста, так и для полного теста батареи, и когда включаем тест батареи, и не важно какой вариант, то оба выключателя будут включены, а с условием последнего состояния будет включен только тот выключатель, который мы включили первым. Также, строка **command_timeout** будет опрашивать статус у сервера сетевого ИБП и выставлять выключателю реальный статус

```
{% raw %}
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
{% endraw %}
```

## Создадим сенсоры

> Важно! Данные сенсоры как дополнение и не являются обязательными, делаем на свое усмотрение

* Первый сенсор **UPS Load Watts** показывает нагрузку в ваттах, вместо %
* Второй сенсор создал с аттрибутом уровня заряда батареи, чтобы вывести в карточке как аттрибут, используя пользовательскую интеграцию [Home Assistant. Multiple Entity Row](https://github.com/benct/lovelace-multiple-entity-row)

Для понимания о каком аттрибуте идет речь
```
{% raw %}
  - type: custom:fold-entity-row
    head:
      entity: sensor.ups_cyberpower_livingroom
      name: ИБП
      type: custom:multiple-entity-row
      secondary_info:
        attribute: Уровень заряда
        name: Батарея
        unit: '%'
        
{% endraw %}
```

Сами сенсоры
> Важно! В строке `{% raw %}value_template: "{{ states('sensor.ups_load') | float(default=0) / 100 * 720 | round(0) }}"
{% endraw %}` есть цифра `720`. Это цифра означает мощность вашего ИБП. Смотрите строку `ups.realpower.nominal: 720`

Узнать мощность ИБП можно командой
```
upsc ups@192.168.1.200 ups.realpower.nominal
```

Сверяйте показания сенсора нагрузки, например с программой WinNUT-Client. Скачать WinNUT-Client можно [здесь](https://github.com/gawindx/WinNUT-Client/releases)

![image](https://user-images.githubusercontent.com/64090632/143961494-9ac84a08-7dcc-4083-8667-7b86bc4bbe83.png)


```
{% raw %}
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
{% endraw %}
```

## Создадим группу сенсоров

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

### Суть проблемы и зачем это нужно?

На Synology upsc и upscmd взаимодействуют с upsd, используя модель клиент/сервер. К сожалению, upsmcd недоступен в операционной системе Synology DiskStation Manager (DSM). Читаем [Synology NAS beeper](https://github.com/renatopanda/synology-nas-beeper) или [Problems with UPS Server after DSM 6.2.4-25556 update](https://community.synology.com/enu/forum/1/post/141910?page=1&sort=oldest).

Использовать такую команду, подключившись с OS Home Assistant к NAS Synology, у нас не получится вызвать команду. Нам сообщат об ошибке.
```
ssh user@192.168.1.200 -p 330 upscmd -u hassmon -p 12345678 ups@localhost:3493 beeper.enable
```

Можно получить только статус сенсора
```
ssh localshare@192.168.1.200 -p 330 upsc ups@localhost
```


Если попытаетесь в **OS Home Assistant**, через **SSH** запустить `upsc ups@192.168.1.200`, то получите подобное сообщение, что такой команды нет

![image](https://user-images.githubusercontent.com/64090632/143955324-e4043897-5ee1-47ac-80e4-7dee64431a58.png)

При попытке установить пакет nut `apk add nut` получите сообщение, что такого пакета нет

![image](https://user-images.githubusercontent.com/64090632/143955987-4ec08401-2079-46c4-8282-6fa1fac99288.png)

***

### Вариант решения проблемы

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


> Важно! После того, как вы добавите ссылки в `/etc/apk/repositories` и установите пакет `nut`, то это будет работать до тех пор, пока вы полностью не перезагрузите OS Home Assistant. Для понимания: когда мы полностью перезагружаем OS Home Assistant, то OS Home Assistant восстанавливает все к исходному и все наши настройки и пакеты будут стерты и удалены, и придется по новой выполнять процедуру. Проблему можно решить запуском скрипта, но, скрипт будем запускать не с помощью **shell_command**, а с помощью самого аддона **SSH & Web Terminal**.

Создадим скрипт который будет проверять файлик `repositories` по пути `/etc/apk/repositories` и если там не будут ссылки с крайней версии, то добавит добавит 3 ссылки на крайние и тестовые версии для скачивания и установки пакета `nut`, а также проверит установлен ли пакет `nut`, если пакет `nut` установлен, то скрипт пропустит этот шаг и не будет ставить пакет `nut`. Этот скрипт нужно поместить в автоматизацию при загрузке Home Assistant. Он будет каждый раз сверять и если Home Assistant все затрет, то скрипт все установит.

**1)** Создадим папку `scripts` в папке `config`
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

FILENAME=/etc/apk/repositories
if [ `grep -l "nl.alpinelinux.org" $FILENAME` ]; then
  echo "Все отлично. Ссылки в репозитории добавлять не нужно"
else
  echo "Упс. Home Assistant все удалил. Сейчас добавим ссылки в репозитории"
  sleep 2
cat <<_EOF_ >> /etc/apk/repositories
http://nl.alpinelinux.org/alpine/edge/main
http://nl.alpinelinux.org/alpine/edge/community
http://nl.alpinelinux.org/alpine/edge/testing
_EOF_
  echo "Готово"
fi


apk -e info nut > /etc/apk/packages.txt
FILENAME=/etc/apk/packages.txt
if [ `grep -w "nut" $FILENAME` ]; then
  echo "Все отлично. Cтавить пакет NUT не требуется"
else
  echo "Упс. Home Assistant все удалил. Сейчас установим пакет NUT"
  apk add nut
  echo "Готово"
fi

```

**5)** Создадим скрипт на запуск скрипта `install_nut.sh` используя аддон **SSH & Web Terminal**

```
alias: Установка NUT
sequence:
  - service: hassio.addon_stdin
    data:
      addon: a0d7b954_ssh
      input: /config/scripts/install_nut.sh
mode: single

```

Перед созданием скрипта, можно проверить запуск скрипта `install_nut.sh` через службу, используя аддон **SSH & Web Terminal**

![image](https://user-images.githubusercontent.com/64090632/144157811-add59d60-dfa9-4396-8989-5ffa0d3c9d51.png)


***

## Выключатель звукового оповещения

Примеры как использовать данные службы для включения или выключения звука

Включаем звук
```
service: hassio.addon_stdin
data:
  addon: a0d7b954_ssh
  input: upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 beeper.enable
```

Выключаем звук
```
service: hassio.addon_stdin
data:
  addon: a0d7b954_ssh
  input: upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 beeper.disable
```

Пример выключателя с помощью интеграции [Template Switch](https://www.home-assistant.io/integrations/switch.template/)
```
{% raw %}
switch: 
  - platform: template
    switches:
      ups_beeper:
        friendly_name: 'Звуковое оповещение'
        value_template: '{{ is_state("sensor.ups_beeper_status","enabled") }}'
        turn_on:
          service: hassio.addon_stdin
          data:
            addon: a0d7b954_ssh
            input: upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 beeper.enable
        turn_off:
          service: hassio.addon_stdin
          data:
            addon: a0d7b954_ssh
            input: upscmd -u hassmon -p 12345678 ups@192.168.1.200:3493 beeper.disable
        icon_template: >-
          {% if is_state("sensor.ups_beeper_status","enabled") %}
            mdi:volume-high
          {% else %}
            mdi:volume-off
          {% endif %}
{% endraw %}
```



## Источники
* [Network UPS Tools](https://networkupstools.org)
* [Network UPS Tools Developer Guide](https://networkupstools.org/docs/developer-guide.chunked/index.html)
* [Home Assistant. Network UPS Tools](https://www.home-assistant.io/integrations/nut/)
* [Home Assistant. Command line Switch](https://www.home-assistant.io/integrations/switch.command_line/)
* [Home Assistant. Multiple Entity Row](https://github.com/benct/lovelace-multiple-entity-row)
* [Home Assistant. Fold Entity Row](https://github.com/thomasloven/lovelace-fold-entity-row)
* [Home Assistant. Group](https://www.home-assistant.io/integrations/group/)
* [Home Assistant. Template Switch](https://www.home-assistant.io/integrations/switch.template/)
* [Disable UPS beeper (USB) in Synology NAS](https://github.com/renatopanda/synology-nas-beeper)
