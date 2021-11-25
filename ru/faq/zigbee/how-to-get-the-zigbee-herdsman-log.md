# Ведение журнала отладки Zigbee herdsman. Как получить лог zigbee herdsman?


Делать нужно через консоль.

1) Останавливаем службу zigbee2mqtt командой
```
/etc/init.d/zigbee2mqtt stop
```

2) Запускаем zigbee с DEBUG
```
ZIGBEE2MQTT_DATA=/etc/zigbee2mqtt/ DEBUG=zigbee-herdsman* node /opt/zigbee2mqtt/index.js > /tmp/log/z2m.log 2>&1
```

3) Ждем когда заработает zigbee2mqtt и откроется веб страница zigbee2mqtt
4) Добавляем устройство в zigbee2mqtt
5) Смотрим в лог z2m.log, который находится по пути /tmp/log/z2m.log


## Команды для управления службой zigbee2mqtt

Запустить zigbee2mqtt
```
/etc/init.d/zigbee2mqtt start
```

Остановить zigbee2mqtt
```
/etc/init.d/zigbee2mqtt stop
```

Перезагрузить zigbee2mqtt
```
/etc/init.d/zigbee2mqtt restart
```


Посмотреть статус работы zigbee2mqtt
```
/etc/init.d/zigbee2mqtt status
```

Просмотреть весь список команд zigbee2mqtt
```
/etc/init.d/zigbee2mqtt
```


## Источник
Дополнительная информация про [Zigbee-herdsman debug logging](https://www.zigbee2mqtt.io/guide/usage/debug.html#enabling-logging)
