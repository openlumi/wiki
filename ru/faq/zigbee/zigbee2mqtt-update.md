---

categories:
- zigbee
- update
- use-cases

software:
- zigbee2mqtt
---
# Обновляем zigbee2mqtt

На openwrt версии 19 и 21 можно установить zigbee2mqtt версии 1.22.2 (инфа актуальна на момент написания статьи 22.01.2022, но суть будет та же, даже если другая версия zigbee2mqtt). Если ставите zigbee2mqtt на чистый шлюз, то проблем не будет и при установке zigbee2mqtt установится последняя версия. Вам достаточно запустить zigbee2mqtt и, если девайсы добавляете первый раз, то сделать сопряжение устройств со шлюзом или, если ранее они были добавлены, то восстановить из бэкапа. Как это делается, читаем [здесь](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Делаем-бэкап-zigbee2mqtt). 

Если мы обновляем установленный zigbee2mqtt на более свежую версию, то могут возникнуть проблемы, поэтому рекомендуется делать так:

1. Удаляем zigbee2mqtt через LuCI
![image](https://user-images.githubusercontent.com/64090632/150642720-23cdad4e-68b9-42ac-87dd-9b9da77cd1a5.png)
1. Делаем бэкап папки `/etc/zigbee2mqtt`
1. Удаляем папку `/etc/zigbee2mqtt` полностью
1. Перезагружаем шлюз(можно не делать, но рекомендуется)
1. Устанавливаем zigbee2mqtt последней версии через LuCI
![image](https://user-images.githubusercontent.com/64090632/150642909-7ac323a1-5485-4ccc-9549-aa6eeae65e20.png)
1. Останавливаем службу zigbee2mqtt
1. Восстанавливаем из бэкапа в `/etc/zigbee2mqtt`
1. Запускаем службу zigbee2mqtt


