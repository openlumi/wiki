# MQTT мост

### Зачем нужен MQTT мост?
MQTT мост позволяет соединить два или более MQTT брокера вместе и используется для обмена сообщениями между системами.

Видео
[MQTT Bridge: NAS Synology. Docker. OpenWRT](https://youtu.be/Th6fD4bEhTM)

Документация
* [Настройка MQTT моста в аддоне MQTT Home Assistant](https://community.home-assistant.io/t/instruction-manual-configuring-the-mqtt-bridge-on-the-mosquito-broker-addon/339151)
* [Mosquitto. mosquitto.conf — the configuration file for mosquitto](https://mosquitto.org/man/mosquitto-conf-5.html)
* [Mosquitto MQTT Bridge -Usage and Configuration](http://www.steves-internet-guide.com/mosquitto-bridge-configuration/)

Ниже привел свой пример настройки MQTT bridge. Это позволит повысить безотказность работы умного дома. В случае выхода из строя чего либо, то ляжет только определенный участок, а не весь умный дом.
1. NAS отвечает за все зоны
1. Шлюз1 отвечает за зоны: коридор\санузел\кухню
1. Шлюз2 отвечает за зоны: гостиная\спальня 1\спальня 2

Варианты сбоя
1) NAS выключился, то шлюз 1 и шлюз 2 смогут общаться между собой без главного сервера. Автоматизация в доме продолжает работать, будто NAS не был выключен
2) NAS работает, шлюз 1 выключен, шлюз 2 работает. Работает автоматизация только в гостиной и в спальнях
3) NAS работает, шлюз 1 включен, шлюз 2 выключен. Работает автоматизация только в коридоре, в санузле и на кухне

## Вариант 1. Схема настройки MQTT моста

**Пример настройки MQTT bridge для шлюза под номером 1 (AqaraGate01). Который будет передавать топики на главный сервер, но при этом мы не подключаемся к шлюзу под номером 2 (AqaraGate02)**

![MQTT Bridge diagram 01](https://user-images.githubusercontent.com/64090632/143300496-d020b570-b366-4c13-9de8-36cc349e4f6b.jpg)


```
# MQTT Bridge AqaraGate01
# MQTT Bridge 1. Подключение к NAS Home Assistant
connection NAS_Home_Assistant
address 192.168.1.30:2883
listener 1883
remote_clientid AqaraGate01
remote_username MQTT
remote_password MQTT
bridge_attempt_unsubscribe true
cleansession true
start_type automatic
allow_anonymous true
try_private true
topic lumi/# both
topic zigbee2mqtt_gate01/# both
topic homeassistant/# out
```

**Пример настройки MQTT bridge для шлюза под номером 2 (AqaraGate02). Который будет передавать топики на главный сервер и на шлюз под номером 1 (AqaraGate01)**

```
# MQTT Bridge AqaraGate02
# MQTT Bridge 1. Подключение к NAS Home Assistant
connection NAS_Home_Assistant
address 192.168.1.30:2883
listener 1883
remote_clientid AqaraGate02
remote_username MQTT
remote_password MQTT
bridge_attempt_unsubscribe true
cleansession true
start_type automatic
allow_anonymous true
try_private true
topic lumi/# both
topic zigbee2mqtt_gate02/# both
topic homeassistant/# out
```

```
# MQTT Bridge 2. Подключение к шлюзу AqaraGate01
connection AqaraGate01
address 192.168.1.31:1883
bridge_attempt_unsubscribe true
cleansession true
start_type automatic
allow_anonymous true
try_private true
topic # both 0 "" ""
```
## Вариант 2. Схема настройки MQTT моста

![MQTT Bridge diagram 02](https://user-images.githubusercontent.com/64090632/143300459-3d3b7c50-d084-4835-9351-c7b50ef27237.jpg)


Шлюзы по умолчанию подключаются к MQTT брокеру на главном Home Assistant, но если по какой-то причине главный Home Assistant будет выключен или аддон MQTT брокер на главном Home Assistant будет выключен, то шлюзы переключатся друг на друга и будут общаться между собой

**За переключение при не доступном брокере на главном MQTT брокере отвечают эти строчки**
```
address 192.168.1.40:4127, 192.168.1.42:1883
round_robin false 
```
round_robin false  (переключать только, когда первый MQTT брокер не доступен)

round_robin true (подключаться ко всем MQTT брокерам)


## Литература
* [Mosquitto](https://mosquitto.org/man/mosquitto-8.html)
* [Mosquitto MQTT Bridge -Usage and Configuration](http://www.steves-internet-guide.com/mosquitto-bridge-configuration/)
