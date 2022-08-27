---

categories:
- zigbee

---
# Где взять прошивки для модуля zigbee?

> **Важно! Имеются два вида прошивок для модуля zigbee, это для zigbee2mqtt и для ZHA. Если собираетесь использовать ZHA, то необходимо использовать прошивку только для ZHA, а если для zigbee2mqtt, то только для zigbee2mqtt.**


### Где скачать прошивку для модуля zigbee, для работы zigbee2mqtt?
Все прошивки для модуля zigbee находятся [здесь](https://github.com/openlumi/JN-ZigbeeNodeControlBridge-firmware/releases)

***

### Где скачать прошивку для модуля zigbee, для работы ZHA?
Для ZHA надо ставить оригинальную прошивку ZiGate и только baudrate 115200. Прошивку можно скачать [здесь](https://github.com/openlumi/ZiGate/releases)

***


### Зачем нужно прошивать модуль zigbee?
* Купили новый шлюз и накатили openwrt, прошивается модуль zigbee разово, т.е каждый раз прошивать модуль zigbee после сброса шлюза на заводское состояние не требуется
* Решили перейти с zigbee2mqtt на ZHA или наоборот
* Вышла новая версия прошивки. **Важно! Если обновите прошивку, то придется переджойнить все девайсы и сделать Erase PDM**

### Справочная информация

* [Чем отличается Erase PDM от Soft reset?](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Чем-отличается-Erase-PDM-от-Soft-reset%3F)
* [Если сбросил шлюз к заводским настройкам, нужно ли делать Erase PDM?](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Если-сбросил-шлюз-к-заводским-настройкам,-нужно-ли-делать-Erase-PDM%3F)

