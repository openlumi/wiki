# Как я могу пробросить устройства на внешний умный дом

## Вступление

**Что такое внешний умный дом?**

Под внешним умным домом понимается, что это может быть какой-то сервер, где крутится умный дом и в нем также стоит MQTT брокер. Для того, чтобы внешний умный дом видел девайсы со шлюза, нужно либо настроить MQTT мост, либо на шлюзе указываем MQTT брокер умного дома.

* **Прямое подключение к MQTT брокеру на шлюзе** - на шлюзе стоит локальный MQTT брокер, подключаемся к шлюзу из внешнего сервера или, если на шлюзе стоит платформа умного дома, то подключаемся к локальному MQTT брокеру

* **Прямое подключение к внешнему MQTT брокеру** - когда на шлюзе не стоит MQTT брокер и в конфигурационных настройках служб, такие как: zigbee2mqtt, ble2mqtt, lumimqtt указывается IP адрес, порт, логин и пароль от внешнего MQTT брокера

* **MQTT мост** - когда на шлюзе стоит MQTT брокер и установленные службы на шлюзе, такие как: zigbee2mqtt, ble2mqtt, lumimqtt, смотрят на локальный MQTT брокер, а сам локальный MQTT брокер подключается к внешнему MQTT брокера



***

## Прямое подключение к MQTT брокеру на шлюзе

Если будем использовать этот вариант, то править конфиги внутренних служб требуется только в том случае, если включили авторизацию на локальном MQTT брокере. По умолчанию доступ к локальному MQTT брокеру для внешних источников закрыт. Чтобы разрешить доступ извне, необходимо добавить строчки

**Если доступ без авторизации**
```
listener 1883
allow_anonymous true
```

**Если доступ с авторизацией**
> Важно! В файле `passwordfile` должен быть указан логин и пароль. В противном случае доступ будет закрыт.

```
listener 1883
password_file /etc/mosquitto/passwordfile
```

* Если подключаемся к MQTT брокеру с внешнего источника, то указываем IP адрес шлюза, порт и логин\пароль(если включена авторизация)
* Если подключаемся к MQTT брокеру локально, например на шлюзе стоит Home Assistant и установив клиент MQTT, то указываем localhost и указываем логин\пароль(если включена авторизация)

***


## Прямое подключение к внешнему MQTT брокеру

Для прямого подключения к внешнему MQTT брокеру, необходимо в конфигурации служб, таких, как zigbee2mqtt, lumimqtt, ble2mqtt указать IP и порт от внешнего MQTT брокера, а также, если у вас на внешнем MQTT брокере включена авторизация, то надо указать логин и пароль

### Zigbee2mqtt
Для примера рассмотрим настройки в zigbee2mqtt. Настроить можно либо через веб интерфейс, либо в самом `configuration.yaml`, который находится по пути `/etc/zigbee2mqtt/configuration.yaml`.

**1)** Вариант настройки авторизации в веб интерфейсе zigbee2mqtt.

![image](https://user-images.githubusercontent.com/64090632/144246889-c93443d0-d57b-42d8-967a-aeb96578d666.png)


***

**2)** Вариант настройки в `configuration.yaml`, который находится по пути `/etc/zigbee2mqtt/configuration.yaml`.

Для редактирования файла `configuration.yaml` можете использовать nano в консоли:
```
nano /etc/zigbee2mqtt/configuration.yaml
```

Нужно настроить только эти строки, чтобы ваш zigbee2mqtt подключился к внешнему MQTT брокеру. Про настройки и их описание, читаем [здесь](https://www.zigbee2mqtt.io/guide/configuration/mqtt.html#server-connection).

```
server: mqtt://192.168.1.50:1883
user: укажите логин
password: укажите пароль
```

Полный конфиг `configuration.yaml`
```
homeassistant: true
permit_join: false
mqtt:
  base_topic: zigbee2mqtt
  server: mqtt://localhost
  client_id: GateLivinRoom
  keepalive: 60
  reject_unauthorized: false
  version: 4
  user: укажите логин
  password: укажите пароль
serial:
  port: /dev/ttymxc1
  adapter: zigate
advanced:
  baudrate: 115200
  log_level: info
  log_directory: /tmp/log/zigbee2mqtt/%TIMESTAMP%
  log_file: log.txt
  log_rotation: true
  log_output:
    - file
  homeassistant_legacy_entity_attributes: false
  legacy_api: false
  ikea_ota_use_test_url: false
  log_syslog:
    app_name: Zigbee2MQTT
    eol: /n
    host: localhost
    localhost: localhost
    path: /dev/log
    pid: process.pid
    port: 123
    protocol: tcp4
    type: '5424'
  channel: 11
devices: devices.yaml
groups: groups.yaml
frontend:
  port: 8090
experimental:
  new_api: true
device_options:
  legacy: false
availability: true
ota:
  disable_automatic_update_check: true

```

***
### Lumimqtt

> Важно! При первом включении подсветки шлюза, подсветка может не включиться. Выключите и снова включите подсветку и если не загорится, то выберите другой цвет, тогда подсветка включится

В файлике `lumimqtt` также указываем IP адрес и порт от внешнего MQTT брокера, и если у вас на внешнем MQTT брокере включена авторизация, то надо указать логин и пароль

Стандартная конфигурация `lumimqtt`
```
{
    "mqtt_host": "localhost",
    "mqtt_port": 1883,
    "mqtt_user": "",
    "mqtt_password": "",
    "topic_root": "lumi/{device_id}",
    "auto_discovery": true,
    "sensor_retain": false,
    "sensor_threshold": 50,
    "sensor_debounce_period": 60,
    "light_transition_period": 1.0
}
```

Правим только эти строки. Для редактирования файла `lumimqtt.json` можете использовать nano в консоли:
```
nano /etc/lumimqtt.json
```

```
    "mqtt_host": "указываем IP адрес внешнего MQTT брокера, например 192.168.1.50",
    "mqtt_port": 1883,
    "mqtt_user": "указываем логин, если включена авторизация",
    "mqtt_password": "указываем пароль, если включена авторизация",
```


***

## Настройка MQTT моста

Для работы моста необходимо установить пакет `mosquitto-nossl`. Данный пакет `mosquitto-nossl` позволяет настроить mqtt мост и авторизацию. У пакета `mosquitto-ssl` не работает mqtt мост, только авторизация и только как mqtt брокер.

> Важно! Если у вас на шлюзе стоят службы zigbee2mqtt, lumimqtt, ble2mqtt и другие, которые работают через MQTT брокер, и вы включили авторизацию, то необходимо в настройках этих службах указать логин и пароль для подключения к локальному MQTT брокеру. По умолчанию у них не указан логин и пароль. Если этого не сделать при включенной авторизации на MQTT брокере, то службы zigbee2mqtt, lumimqtt, ble2mqtt и другие не смогут подключиться к MQTT брокеру и не смогут работать.


**Как установить пакет `mosquitto-nossl`, читаем: [Как установить и настроить mosquitto?](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Как-установить-и-настроить-mosquitto%3F-Зачем-это-нужно%3F)**


Ниже пример рабочего конфига для работы MQTT моста + включена авторизация. Это не эталонная конфигурация и вы можете настроить по своему, ибо в `mosquitto.conf` есть подробное описание про настройку. Добавлять в `mosquitto.conf`. Для удобства добавьте в самый вверх. Файлик `mosquitto.conf` находится по адресу /etc/mosquitto/mosquitto.conf

> Важно! Если в конфиге не указать топики, например `topic homeassistant/# out`, то топиков не будет, кроме служебных топиков `$SYS`. Поэтому указываете какие топики должны быть добавлены. Сами топики можете посмотреть через MQTT Explorer до того, как включите авторизацию. После включения авторизации впишите эти топики в конфигурационный файлик > mosquitto.conf

Примеры топиков c опцией in/out/both/ . Все опции для одного топика указывать нельзя, что то одно: вход/выход/обе стороны/все топики
```
topic lumi/# #Все топики
topic lumi/# in #Топики на вход
topic lumi/# out #Топики только на выход
topic lumi/# both #Топики в обе стороны
```

> Важно! Копируйте только строки параметров, комментарии не копируйте. Если вы скопируете все с комментариями, то у вас MQTT брокер не запустится. Также проверяйте, чтобы не было пробелов после конца строк параметра. Ниже. для удобства я выложил конфиг без комментов.
```
connection Home Assistant                          # Куда подключаемся. Указываем вместо Home Assistant любое имя
address 192.168.1.108:1883                         # Куда подключаемся. Указываем IP и порт своего внешнего сервера
listener 1883                                      # Вкл. просл порта 1883 для шлюза, чтобы мы могли подкл к шлюзу через MQTT Exploer
password_file /etc/mosquitto/passwordfile          # Включаем авторизацию. В файлике passwordfile указываем логин и пароль
allow_anonymous false                              # Запрещаем доступ для анонимного подключения
remote_clientid Gateway                            # Имя подключаемого клиента к MQTT брокеру. В логах MQTT брокеру будет имя подключаемого клиента 
remote_username mqtt                               # Указываем логин от MQTT брокеру к которому мы подключаемся
remote_password mqtt                               # Указываем пароль от MQTT брокеру к которому мы подключаемся
bridge_attempt_unsubscribe true                    # Отказ от подписки после удаления темы
cleansession true                                  # Подписки и сообщения удаляются
start_type automatic                               # MQTT мост запускается автоматически
try_private true                                   # MQTT брокеру будет видеть, что это не просто клиент, а MQTT мост
topic homeassistant/# out                          # Указываем топик homeassistant на выход, чтобы не перегружать шлюз.
topic zigbee2mqtt/# both                           # Указываем топик zigbee2mqtt на обе стороны, тогда HomeAssistant увидит устройства со шлюза
topic lumi/# both                                  # Указываем топик topic lumi на обе стороны, тогда HomeAssistant увидит устройства со шлюза
```

Для удобства я вывел отдельные строки без комментариев, можете копировать и вставлять сразу в `mosquitto.conf` находящийся по пути `/etc/mosquitto/mosquitto.conf`

**Вариант 1**. Настройка моста с включенной авторизацией для подключения к MQTT на шлюзе
```
connection Home Assistant
address 192.168.1.108:1883
listener 1883
password_file /etc/mosquitto/passwordfile
allow_anonymous false
remote_clientid Gateway
remote_username mqtt
remote_password mqtt
bridge_attempt_unsubscribe true
cleansession true
start_type automatic
try_private true
topic homeassistant/# out
topic zigbee2mqtt/# both
topic lumi/# both
```

**Вариант 2**. Настройка моста с выключенной авторизацией для подключения к MQTT на шлюзе
```
connection Home Assistant
address 192.168.1.108:1883
listener 1883
allow_anonymous true
remote_clientid Gateway
remote_username mqtt
remote_password mqtt
bridge_attempt_unsubscribe true
cleansession true
start_type automatic
try_private true
topic homeassistant/# out
topic zigbee2mqtt/# both
topic lumi/# both
```


## Как включить авторизацию?

Чтобы включить авторизацию в mosquitto, необходимо добавить следующие строки в конфигурационный файлик `mosquitto.conf`
> **Важно! Если у вас, при включенной авторизации и включенным MQTT мостом возникли проблемы при подключении к внешнему MQTT брокеру, например в логах аддона MQTT Home Assistant фиксируются цикличные логи connect и disconnect, то выключите авторизацию и предоставьте доступ для всех `allow_anonymous true` и закомментируйте `#password_file /etc/mosquitto/passwordfile`.**

Закрываем доступ для всех, доступ только с пароля
```
allow_anonymous false
```

Включаем авторизацию. Указываем путь к файлику `passwordfile`, в котором хранятся логин и пароль
```
password_file /etc/mosquitto/passwordfile
```

Создаем файлик `passwordfile`
```
touch /etc/mosquitto/passwordfile
```
В файлик `passwordfile` добавить логин и пароль в таком виде `логин:пароль`
```
mqtt:123456
```

## Команды для управления службой mosquitto

Запустить mosquitto
```
/etc/init.d/mosquitto start
```

Остановить mosquitto
```
/etc/init.d/mosquitto stop
```

Перезагрузить mosquitto
```
/etc/init.d/mosquitto restart
```


Посмотреть статус работы mosquitto
```
/etc/init.d/mosquitto status
```

Просмотреть весь список команд mosquitto
```
/etc/init.d/mosquitto
```


## Источники
* [mosquitto configuration](https://mosquitto.org/man/mosquitto-conf-5.html)
* [mosquitto authentication methods](https://mosquitto.org/documentation/authentication-methods/)
