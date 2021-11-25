# Как обновить версию OpenWRT с 21.02 до .... ?

## Важно! 
> Сброс перед обновлением делать не нужно, так как сброс можно сделать во время обновления `xxxx-squashfs-sysupgrade.bin`, где у вас спросят, сохранить ли настройки или все сбросить. Если выберите не сохранять ничего, то произойдет полный сброс. Обязательно сделайте перед обновлением `xxxx-squashfs-sysupgrade.bin` бэкап.**

### Скриншот с примером
* Если поставить галочку на `Keep setting and retain the current configuration`, то полного сброса не будет и настройки будут сохранены
* Если снять галочку с `Keep setting and retain the current configuration`, то произойдет полный сброс. После перезагрузки поднимется точка доступа OpenWRT и придется подключить шлюз к роутеру WiFi.
* 
![image](https://user-images.githubusercontent.com/64090632/143297606-2300d6d0-8816-4c22-a5d5-9ffad7f5ba04.png)


***
## Резервное копирование

Бэкап будет лежать в папке /tmp
```
tar cvz -f /tmp/backup_$(date +%d-%m-20%y_%H-%M).tar.gz -C /overlay/upper/ /overlay/upper/

```

***

## Обновляем OpenWRT
[Скачиваем образ](https://openlumi.github.io/releases/21.02.1/targets/imx6/generic/) `xxxx-squashfs-sysupgrade.bin` для своего шлюза (смотрим на название файла). Делаем обновление через LuCI. 

> **Важно! Смотрите на название файла xxxx-squashfs-sysupgrade.bin. Ниже пояснение для какого шлюза эти файлы**
> * Для шлюза Aqara ZHWG11LM 
> `openlumi-21.02.1-imx6-aqara_zhwg11lm-squashfs-sysupgrade.bin`
> * Для шлюза Xiaomi DGNWG05LM 
> `openlumi-21.02.1-imx6-xiaomi_dgnwg05lm-squashfs-sysupgrade.bin`

![image](https://user-images.githubusercontent.com/64090632/143297630-1f609a42-651f-46d2-abf6-a56e3456545c.png)


System => Backup/Flash Firmware
![image](https://user-images.githubusercontent.com/64090632/141359903-58c2f4ac-5078-4927-86e1-619a49d883fd.png)
