---

categories:
- zigbee
- backup
- use-cases

software:
- zigbee2mqtt
---
# Делаем бэкап zigbee2mqtt

## Вступление

Зачем нужно делать бэкап zigbee2mqtt? Что это даст? Когда вы делаете сопряжение zigbee девайсов со шлюзом через zigbee2mqtt, то девайсы добавляются в zigbee2mqtt и записываются в PDM(флеш-память модуля zigbee). Когда сбрасываем шлюз до начального состояния или переустанавливаем zigbee2mqtt и не нажимаем на Erase PDM, то сопряженные девайсы не стираются и можно быстро восстановить в zigbee2mqtt все девайсы. Достаточно из бэкапа скопировать в /etc/zigbee2mqtt файлики

> Важно! Не нажимайте на Erase PDM без необходимости. Не нужно нажимать на Erase PDM, если делаете сброс шлюза до начального состояния. Использовать Erase PDM нужно в том случае, если вы хотите окончательно удалить все девайсы с флеш-памяти модуля zigbee и не хотите, чтобы они были восстановлены после копирования файлов в /etc/zigbee2mqtt. Например продаете шлюз, шлюз будет находиться в другом помещении и там будут другие девайсы или есть проблемы с чипом zigbee(не спариваются девайсы, не добавляются в zigbee2mqtt, тогда многократное стирание флеш-памяти модуля zigbee иногда помогает решить проблему). Про Erase PDM читаем [здесь](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Чем-отличается-Erase-PDM-от-Soft-reset%3F)

**В папке /etc/zigbee2mqtt хранятся файлы которые отвечают за:**

* configuration.yaml - настройки zigbee2mqtt Подробно читаем [здесь](https://www.zigbee2mqtt.io/guide/configuration/)
* database.db - база данных
* devices.yaml - записываются ID, имена и параметры девайсов [здесь](https://www.zigbee2mqtt.io/guide/configuration/devices-groups.html#common-device-options)
* groups.yaml - группа девайсов. Подробно читаем [здесь](https://www.zigbee2mqtt.io/guide/usage/groups.html#configuration)


## Как сделать бэкап? 

Есть два варианта бэкапа, полный или выборочный

**1)** Полный бэкап. Здесь делается бэкап всего шлюза.
```
tar cvz -f /tmp/backup_$(date +%d-%m-20%y_%H-%M).tar.gz -C /overlay/upper/ /overlay/upper/
```

**2)** Выборочный бэкап. Здесь делается бэкап только zigbee2mqtt
```
tar cvz -f /tmp/backup_zigbee2mqtt$(date +%d-%m-20%y_%H-%M).tar.gz /etc/zigbee2mqtt
```

## Как восстановить девайсы zigbee2mqtt из бэкапа?

> Важно! Перед восстановлением из бэкапа, сперва нужно остановить службу zigbee2mqtt, а после восстановления из бэкапа запустить службу zigbee2mqtt

Остановить zigbee2mqtt
```
/etc/init.d/zigbee2mqtt stop
```

Запустить zigbee2mqtt
```
/etc/init.d/zigbee2mqtt start
```

**1)** Если сделали выборочный бэкап, то достаточно закинуть бэкап в папку tmp и распаковать бэкап командой.

```
tar xzv -C / -f /tmp/backup_zigbee2mqtt_XXXXXX.tar.gz /etc/zigbee2mqtt
```

**2)** Если сделали полный бэкап, то можете вручную извлечь файлики из папки /etc/zigbee2mqtt и скопировать вручную на шлюз в папку /etc/zigbee2mqtt средствами WinSCP или TotalCMD. Как подключиться к шлюзу через Total Commander [читаем здесь](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Подключаемся-к-шлюзу-через-Total-Commander). 


## Литература

[Zigbee2MQTT документация](https://www.zigbee2mqtt.io)
