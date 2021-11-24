
Скачайте [образ](https://openlumi.github.io/releases/21.02.1/targets/imx6/generic/) xxxx-squashfs-sysupgrade.bin c добавленными фидами для своего шлюза и обновите через LuCI. 
* Для шлюза Aqara ZHWG11LM 
`openlumi-21.02.1-imx6-aqara_zhwg11lm-squashfs-sysupgrade.bin`
* Для шлюза Xiaomi DGNWG05LM 
`openlumi-21.02.1-imx6-xiaomi_dgnwg05lm-squashfs-sysupgrade.bin`

![image](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/blob/main/image/squashfs-sysupgrade.bin.jpg)

System => Backup/Flash Firmware
![image](https://user-images.githubusercontent.com/64090632/141359903-58c2f4ac-5078-4927-86e1-619a49d883fd.png)

Во время перепрошивки у вас спросят:
* Если снять все галочки, то все настройки будут стерты. После перезагрузки поднимется точка доступа OpenWRT
* Если поставить галочку "Keep setting and retain the current configuration", то все настройки будут сохранены
![sysupgrade-checkbox](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/blob/main/image/squashfs-sysupgrade-checkbox.jpg)
