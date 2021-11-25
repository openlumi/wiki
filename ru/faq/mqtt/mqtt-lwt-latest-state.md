# MQTT LWT последнее состояние

[Стартовая страница WiKi](https://github.com/DivanX10/wiki#readme)

## Вступление
Last Will and Testament feature of MQTT, что в переводе "Последняя воля и завещание". Для чего это нужно? Данная функция нужна для уведомления других клиентов о том, что клиент отключен. Причина может быть любая: выключен MQTT брокер, девайс отвалился от сети, у шлюза отвалился WiFi. Благодаря такой функции LWT вы можете знать текущее состояние устройства или MQTT брокера.




## Общие сведения

Опытным путем выявлено, что MQTT мост может передавать актуальные статусы offline\online `(zigbee2mqtt/bridge/state = offline\online)` только в том случае, если шлюз включен, а также может передавать актуальные статусы девайсов `(zigbee2mqtt/FRIENDLY_NAME/availability = offline\online)`, когда шлюз работает и MQTT брокер запущен.

Если шлюз будет обесточен, то MQTT мост не сможет передать актуальный статус offline\online `(zigbee2mqtt/bridge/state = offline\online)`, а также не передаст текущий статус девайсов `(zigbee2mqtt/FRIENDLY_NAME/availability = offline\online)`

В таком случае есть специальная служебная информация `(SYS/broker/connection/#)`, которая следит за состоянием соединения. Если значение равно 1, соединение активно, если 0, то оно неактивно.

Если у вас есть платформа умного дома и вам важно отслеживать состояние MQTT брокера на шлюзе, то можно создать сенсор, который будет отслеживать состояние подключения к MQTT брокера.

В моем варианте выступает Home Assistant, где я буду использовать два сенсора: RestFull и mqtt сенсор `(SYS/broker/connection/#)`. Зачем два сенсора? Все дело в том, что если на шлюзе MQTT брокер будет выключен, то статусы MQTT моста offline\online `(zigbee2mqtt/bridge/state = offline\online)` прилетят на второй MQTT и Home Assistant отобразит, что девайсы не доступны, но если шлюз полностью обесточен, то статусы MQTT моста offline\online `(zigbee2mqtt/bridge/state = offline\online)` не прилетят на второй MQTT брокер и второй MQTT брокер не будет знать, что первый MQTT брокер (шлюз) выключены, он покажет статус online. Чтобы решить данную проблему, необходимо задействовать RestFull, который будет следить за состоянием любого сенсора и который выберем мы для отслеживания. Если SYS/broker/connection = 0 и RestFull сенсор будет недоступным, то сработает автоматизация, которая пошлет топик zigbee2mqtt/bridge/state = offline, тогда Home Assistant отобразит, что девайсы не доступны  

![mqtt_broker_status](https://user-images.githubusercontent.com/64090632/143300851-51920f33-14b7-4b80-9a04-4fded715be11.jpg)


## Примеры

### Сенсоры
Пример сенсора, который следит за MQTT Broker и за Home Assistant. Это нужно для автоматизации. Если шлюз будет обесточен и оба сенсора будут иметь значение off, то будет статус "Выключен". В таком случае сработает триггер и отправится топик, который выставит статус MQTT брокера в offline и тогда Home Assistant отобразит, что девайсы не доступны. Как настроить работу RESTFull сенсора и как работает автоматизация, читаем [здесь](https://zen.yandex.ru/media/id/5f5bea45267c75477b342dab/rezerviruem-servery-home-assistant-6037f38bd4391d5d927ee7d5)

```
{% raw %}
binary_sensor:
  - platform: mqtt
    name: "MQTT Broker connection GateLivingRoom"
    state_topic: "$SYS/broker/connection/GateLivingRoom/state"
    payload_on: 1
    payload_off: 0


  - platform: rest
    resource: http://192.168.1.20:8123/api/states/binary_sensor.ping_gatelivingroom
    name: "rest ping GateLivingRoom"
    force_update: true
    headers:
      authorization: !secret token_rest_ping_gatelivingroom
      content-type: 'application/json'
    value_template: "{{ value_json.state }}"
    device_class: connectivity


sensor:
  - platform: template
    sensors:
      gatelivingroom_status:
        friendly_name: "Статус шлюза в Гостиной"
        value_template: >
           {% set ping = states('binary_sensor.rest_ping_gatelivingroom') %}
           {% set mqtt_broker = states('binary_sensor.mqtt_broker_connection_gatelivingroom') %}
           {% if ping == 'on' and mqtt_broker == 'on' %} В сети
           {% elif ping == 'on' and mqtt_broker == 'off' %} Home Assistant
           {% elif ping in ('unknown', 'unavailable') and mqtt_broker == 'on' %} MQTT
           {% elif ping in ('unknown', 'unavailable') and mqtt_broker == 'off' %} Выключен
           {% endif %}
        icon_template: >
           {% set ping = states('binary_sensor.rest_ping_gatelivingroom') %}
           {% set mqtt_broker = states('binary_sensor.mqtt_broker_connection_gatelivingroom') %}
           {% if ping in ('unknown', 'unavailable') and mqtt_broker == 'off' %} mdi:server-network-off
           {% else %} mdi:server-network
           {% endif %}
        attribute_templates:
          MQTT Broker: "{{ states('binary_sensor.mqtt_broker_connection_gatelivingroom') }}"
          Ping: "{{ states('binary_sensor.rest_ping_gatelivingroom') }}"
{% endraw %}
```

### Автоматизация
```
alias: 'Шлюз в гостиной: Шлюз обесточен. Статус MQTT брокера OFFLINE'
description: ''
trigger:
  - platform: state
    entity_id: sensor.gatelivingroom_status
    to: Выключен
condition: []
action:
  - service: mqtt.publish
    data:
      topic: zigbee2mqtt_gatelivingroom/bridge/state
      payload: offline
  - service: notify.notify
    data:
      title: '*Шлюз в гостиной*'
      message: Шлюз вероятно завис или обесточен. Требуется проверка
mode: single

```


## Литература
* [Mosquitto](https://mosquitto.org/man/mosquitto-8.html)
* [Last Will and Testament - MQTT](https://www.hivemq.com/blog/mqtt-essentials-part-9-last-will-and-testament/)
* [Mosquitto MQTT Bridge -Usage and Configuration](http://www.steves-internet-guide.com/mosquitto-bridge-configuration/)
* [RESTful Sensor](https://www.home-assistant.io/integrations/sensor.rest)
* [Резервируем серверы Home Assistant](https://zen.yandex.ru/media/id/5f5bea45267c75477b342dab/rezerviruem-servery-home-assistant-6037f38bd4391d5d927ee7d5)



