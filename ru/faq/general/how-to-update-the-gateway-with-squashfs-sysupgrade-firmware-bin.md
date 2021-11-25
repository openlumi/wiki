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
