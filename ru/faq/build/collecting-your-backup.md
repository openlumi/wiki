#Собираем свой бэкап

Перед созданием бэкапа для общего пользования рекомендуется сбрасывать шлюз в нулевое состояние, это сотрет все свои личные настройки и ваши личные настройки не будут у других пользователей. Также, если будете выкладывать свой вариант бэкапа, то указывайте какая версия OpenWRT и что установлено.


**1)** Сбрасываем настройки шлюза до нулевого состояние и удаляем все файлы

```
rm -rf /overlay/upper/.* /overlay/upper/* || reboot
```

**2)** Ставим набор программ, которые считаете нужным или можно установить набор пакетов с этого скрипта

```
 mc - Файловый менеджер Midnight Commander
 nano - Текстовый редактор Nano
 lumimqtt - MQTT agent for Xiaomi Lumi gateway. Ставится lumimqtt и копируется конфигурационный файлик lumimqtt.json в /etc/
 mpd-full - Music Player Daemon. Создается папка MPD в корне с подпапками music и playlists + копируется готовый конфигурационный файл с настройками MPD
 mosquitto-nossl - MQTT брокер
 node - Node Js - это платформа на основе JavaScript
 node-zigbee2mqtt - Установка Zigbee2mqtt + добавление готового конфига для прошивки c baudrate 1000000
 sshpass - Неинтерактивный вход по SSH
 libssh - SSH библиотека
 libssh2-1 - SSH библиотека
 openssh-sftp-client - Позволяет осуществлять доступ по протоколу SFTP
 openssh-client-utils - В данном пакете содержатся пакеты openssh-client, openssh-keygen
 luci-theme-bootstrap - LuCI themes, верхняя панель будет по центру, вместо уехавшей панели вправо
 htop - монитор процессов в консоли
 python3-pymysql - это библиотека PyMySQL позволяющая подключиться в MySQL
```


```
wget https://raw.githubusercontent.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/main/scripts/initial_installation_for_openwrt.sh -O - | sh 2>&1 | tee /mnt/basic_installation.log 
```


**3)** Если ставим Home Assistant, то после установки лучше не проходить первичную настройку, а если все таки прошли, то надо удалить в папке .storage все файлы, там должно быть пусто. Папка .storage расположена здесь `/etc/homeassistant/.storage`. Скрипты для установки [Home Assistant](https://github.com/DivanX10/OpenWRT-and-Home-Assistant/releases)



**4)** Если бэкап делаем для шлюза Xiaomi DGNWG05LM, то ставим python3-light с включенным bluetooth. Это нужно для работы интеграции ble_monitor и ставим интеграцию ble_monitor без входа в Home-Assistant, если для шлюза Aqara ZHWG11LM, то пропускаем этот шаг. Как ставить интеграцию ble_monitor, читаем [здесь](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Как-установить-интеграцию-Passive-BLE-Monitor%3F). Скачайте этот пакет [python3-light_3.9.9-2_arm_cortex-a9_neon_for_ble_monitor.ipk](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/raw/main/packages/python3-light_3.9.9-2_arm_cortex-a9_neon_for_ble_monitor.ipk) в папку tmp и запустите командой, а после того, как переустановите пакет python3-light, перезагрузите шлюз командой `reboot`.

```
opkg install /tmp/python3-light_3.9.9-2_arm_cortex-a9_neon_for_ble_monitor.ipk --force-reinstall
```

**5)** Редактируем файлик wireless в `/etc/config`. Это нужно для того, чтобы после восстановления бэкапа и перезагрузки шлюза, поднялась точка доступа OpenWRT. 

> Внимание! Рекомендуется это делать в архиве бэкапа у себя на ПК. Если это делать на шлюзе, то перед редактированием скопируйте файл wireless к себе на ПК, а после можете вставить в wireless код ниже. Ни в коем случае не перезагружайте шлюз, иначе после перезагрузки поднимется точка доступа OpenWRT. Поэтому, если уж внесли изменение, то не перезагружайте шлюз, а сразу сделайте полный бэкап, а после в wireless верните как было.   

Для того, чтобы поднялась точка доступа OpenWRT, в wireless вставляем следующее

```

config wifi-device 'radio0'
	option type 'mac80211'
	option channel '11'
	option hwmode '11g'
	option path 'soc0/soc/2100000.aips-bus/2190000.usdhc/mmc_host/mmc0/mmc0:0001/mmc0:0001:1'

config wifi-iface 'default_radio0'
	option device 'radio0'
	option network 'wwan'
	option mode 'sta'
	option ssid '$0102030405$'

config wifi-device 'radio1'
	option type 'mac80211'
	option channel '11'
	option hwmode '11g'
	option path 'soc0/soc/2100000.aips-bus/2190000.usdhc/mmc_host/mmc0/mmc0:0001/mmc0:0001:1+1'

config wifi-iface 'default_radio1'
	option device 'radio1'
	option network 'lan'
	option mode 'ap'
	option ssid 'OpenWrt'
	option encryption 'none'


```

**6)** Создаем полный бэкап шлюза и присваиваем имя архиву

```
tar cvz -f /tmp/backup_укажите_имя_архива.tar.gz -C /overlay/upper/ /overlay/upper/
```
