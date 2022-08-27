---

categories:
- software

software:
- lumimqtt
---
# Как обновить версию OpenWRT с 21.02 до .... ?

> **Важно!** Сброс перед обновлением делать не нужно, так как сброс можно сделать во время обновления `xxxx-squashfs-sysupgrade.bin`, где у вас спросят, сохранить ли настройки или все сбросить. Если выберите не сохранять ничего, то произойдет полный сброс. Обязательно сделайте перед обновлением `xxxx-squashfs-sysupgrade.bin` бэкап.

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

## Если нужно обновиться с Openwrt 21.02 до Openwrt 21.02.01

**1)** Скачиваем для своего шлюза Xiaomi DGNWG05LM или Aqara ZHWG11LM sysupgrade. Ссылка на [прошивки](https://openlumi.github.io/releases/21.02.1/targets/imx6/generic/)

* Для Xiaomi DGNWG05LM [openlumi-21.02.1-imx6-xiaomi_dgnwg05lm-squashfs-sysupgrade.bin](https://openlumi.github.io/releases/21.02.1/targets/imx6/generic/openlumi-21.02.1-imx6-xiaomi_dgnwg05lm-squashfs-sysupgrade.bin)
* Для Aqara ZHWG11LM [openlumi-21.02.1-imx6-aqara_zhwg11lm-squashfs-sysupgrade.bin](https://openlumi.github.io/releases/21.02.1/targets/imx6/generic/openlumi-21.02.1-imx6-aqara_zhwg11lm-squashfs-sysupgrade.bin)

![image](https://user-images.githubusercontent.com/64090632/151702014-f8e77994-0572-4569-a267-5e3b17599255.png)

**2)** Загружаем прошивку через Flash new firmware image

![image](https://user-images.githubusercontent.com/64090632/151701847-c2d49993-911c-4f74-837e-447f4b366901.png)


**3)** Перезагружаем шлюз

***

## Если нужно откатиться с Openwrt 21.02.1 до Openwrt 21.02

**1)** Скачиваем для своего шлюза Xiaomi DGNWG05LM или Aqara ZHWG11LM sysupgrade. Ссылка на [прошивки](https://openlumi.github.io/releases/21.02.0/targets/imx6/generic/)

* Для Xiaomi DGNWG05LM [openlumi-21.02.0-imx6-xiaomi_dgnwg05lm-squashfs-sysupgrade.bin](https://openlumi.github.io/releases/21.02.0/targets/imx6/generic/openlumi-21.02.0-imx6-xiaomi_dgnwg05lm-squashfs-sysupgrade.bin)
* Для Aqara ZHWG11LM [openlumi-21.02.0-imx6-aqara_zhwg11lm-squashfs-sysupgrade.bin](https://openlumi.github.io/releases/21.02.1/targets/imx6/generic/openlumi-21.02.1-imx6-aqara_zhwg11lm-squashfs-sysupgrade.bin)

![image](https://user-images.githubusercontent.com/64090632/151702391-16b3bb2f-7633-46ff-be25-549be335230b.png)


**2)** Загружаем прошивку через Flash new firmware image

![image](https://user-images.githubusercontent.com/64090632/151701847-c2d49993-911c-4f74-837e-447f4b366901.png)


**3)** Перезагружаем шлюз

# Как обновить шлюз прошивкой squashfs sysupgrade.bin?

Скачайте [образ](https://openlumi.github.io/releases/21.02.1/targets/imx6/generic/) xxxx-squashfs-sysupgrade.bin c добавленными фидами для своего шлюза и обновите через LuCI.
* Для шлюза Aqara ZHWG11LM
  `openlumi-21.02.1-imx6-aqara_zhwg11lm-squashfs-sysupgrade.bin`
* Для шлюза Xiaomi DGNWG05LM
  `openlumi-21.02.1-imx6-xiaomi_dgnwg05lm-squashfs-sysupgrade.bin`

![squashfs-sysupgrade bin](https://user-images.githubusercontent.com/64090632/143252804-13343774-08d8-41df-9c4f-d7adf618a343.jpg)

System => Backup/Flash Firmware
![image](https://user-images.githubusercontent.com/64090632/141359903-58c2f4ac-5078-4927-86e1-619a49d883fd.png)

Во время перепрошивки у вас спросят:
* Если снять все галочки, то все настройки будут стерты. После перезагрузки поднимется точка доступа OpenWRT
* Если поставить галочку "Keep setting and retain the current configuration", то все настройки будут сохранены
  ![image](https://user-images.githubusercontent.com/64090632/143253024-c49dd612-6e0c-48cb-a0b8-8c1a6c1254db.png)
