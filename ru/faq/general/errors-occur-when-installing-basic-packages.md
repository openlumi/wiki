# При установке базовых пакетов возникают ошибки

[Стартовая страница WiKi](https://github.com/DivanX10/wiki#readme)

**Почему у меня при установки базовых пакетов возникают такие ошибки?**

Collected errors:
 * opkg_install_cmd: Cannot install package lumimqtt.
 * opkg_install_cmd: Cannot install package node.
 * opkg_install_cmd: Cannot install package node-zigbee2mqtt.

**Ответ:** Не настроены на шлюзе фиды. Проверьте, добавлены ли фиды в OpenWRT. Зайдите в LuCI, далее System => Software => Configure opkg . Проверьте, есть ли в списке программ, к примеру эти пакеты lumimqtt, node, node-zigbee2mqtt. Если этих пакетов у вас нет, значит фиды не настроены.
![image](https://user-images.githubusercontent.com/64090632/141359466-bca6fe6e-901b-4f9a-a272-569678b7585b.png)


[Здесь вы можете скачать образ](https://openlumi.github.io/releases/21.02.1/targets/imx6/generic/) xxxx-squashfs-sysupgrade.bin c добавленными фидами для своего шлюза и обновить через LuCI. Во время обновления прошивки галочки не ставим, нам не надо сохранять все предыдущие настройки и все настройки будут стерты. После перезагрузки поднимется точка доступа OpenWRT

* Для шлюза Aqara ZHWG11LM 
`openlumi-21.02.1-imx6-aqara_zhwg11lm-squashfs-sysupgrade.bin`
* Для шлюза Xiaomi DGNWG05LM 
`openlumi-21.02.1-imx6-xiaomi_dgnwg05lm-squashfs-sysupgrade.bin`

![image](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/blob/main/image/squashfs-sysupgrade.bin.jpg)

System => Backup/Flash Firmware
![image](https://user-images.githubusercontent.com/64090632/141359903-58c2f4ac-5078-4927-86e1-619a49d883fd.png)

