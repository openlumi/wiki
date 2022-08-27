---

categories:
- backup
- use-cases

---
# Делаем резервное копирование на NAS Synology

Если у вас есть NAS, то вы можете размещать резервные копии на сетевом диске NAS. Это удобно тем, что не придется хранить бэкапы на шлюзе. Для того, чтобы можно было размещать резервные копии на NAS, необходимо на NAS создать сетевую папку для хранении бэкапов.


1) Ставим пакет `cifsmount` через LuCI

![cifsmount](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/blob/main/image/install%20cifs.JPG)


2) Создадим папку `backup` куда мы примонтируем сетевую папку NAS
```
mkdir -p /mnt/nas/backup
```

3) Монтируем сетевую папку, где нужно указать вместо `логин` и `пароль` свои учетные данные от NAS. Указываем IP адрес NAS и путь к сетевой папке, а также указываем к какой папке мы будем монтировать сетевую папку
```
mount -t cifs -o username=логин,password=пароль,iocharset=utf8,file_mode=0777,dir_mode=0777 //192.168.1.50/BackUP/Gateway /mnt/nas/backup
```

4) Проверяем подключение. Если все сделано верно, то мы увидим подключенный диск //192.168.1.50/BackUP/Gateway
```
df -h
```

***

## Резервное копирование

Вы можете делать полную копию шлюза или частичное. На ваше усмотрение

**Полный бэкап шлюза**

Запуск бэкапа
```
tar cvz -f /mnt/nas/backup/backup_gw-$(date +%d-%m-20%y_%H-%M).tar.gz -C /overlay/upper/ /overlay/upper/
```

***

При желании можно добавить создание бэкапа в планировщик задач (Cron). System => Scheduled Tasks. Для удобства можете воспользоваться [CRON генератором](https://crontab.guru)

На примере запуск бэкапа в 03:00 часа, ежедневно

```
0 3 * * * tar cvz -f /mnt/nas/backup/backup_gw-$(date +%d-%m-20%y_%H-%M).tar.gz -C /overlay/upper/ /overlay/upper/ 

```


***

**Выборочный бэкап**

Данный вариант можно использовать для запуска бэкапа с Home Assistant. Читаем инструкцию [мониторинг папок для бэкапа и не только](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Мониторинг-папок-для-бэкапа-и-не-только)

> Важно! Примеры не являются эталонными. Папку можно создать в любом месте, скрипт также можно размещать в любом месте, главное правильно прописать путь к файлу

Создадим папку для скриптов `scripts`.
```
mkdir /scripts
```

Создадим файл `backup_gateway.sh`
```
touch /scripts/backup_gateway.sh
```

Откроем файл и вставим код
```
nano /scripts/backup_gateway.sh
```

Вставляем код
* В строке `backup` вы указываете нужный путь, где будет храниться бэкап
* В строке `bkpfolder` указываем какие папки нужно бэкапить
* В строке `bkpfile` указываем какие файлы нужно бэкапить
```
#!/bin/bash
backup="/mnt/nas/backup/backup-$(date +%d-%m-%Y_%H-%M).tar"

bkpfolder="
/etc/homeassistant
/etc/zigbee2mqtt
/etc/mosquitto
/root/.ssh
/mpd
"

bkpfile="
/etc/mpd.conf
#/etc/lumimqtt.json
/etc/mpd.state
/etc/init.d/nas_backup
"

echo "Starting a backup"
tar -cvf $backup $OF $bkpfolder $of $bkpfile&&
echo "The backup was completed successfully"
```

Присвоим права на запуск скрипта
```
chmod +x /scripts/backup_gateway.sh
```

Запуск скрипта
```
sh /scripts/backup_gateway.sh
```

При желании можно добавить создание бэкапа в планировщик задач (Cron). System => Scheduled Tasks. Для удобства можете воспользоваться [CRON генератором](https://crontab.guru)

На примере запуск бэкапа в 03:00 часа, ежедневно

```
0 3 * * * sh /scripts/backup_gateway.sh 

```

***

## Авто монтирование диска

1) **Создадим файл `nas_backup` который будет в службах**

> **Важно! Диск указывайте тот, который вы монтируете, в моем случае, это `/mnt/nas/backup`. Вместо логин и пароль указываем свои учетные данные от NAS. Указываем IP адрес NAS и путь к сетевой папке, а также указываем к какой папке мы будем монтировать сетевую папку**

```
cat << "EOF" > /etc/init.d/nas_backup
#!/bin/sh /etc/rc.common

USE_PROCD=1
START=99
STOP=65

start_service(){
mount -t cifs -o username=логин,password=пароль,iocharset=utf8,file_mode=0777,dir_mode=0777 //192.168.1.50/BackUP/Gateway /mnt/nas/backup
}

start() {
mount -t cifs -o username=логин,password=пароль,iocharset=utf8,file_mode=0777,dir_mode=0777 //192.168.1.50/BackUP/Gateway /mnt/nas/backup
}

stop() {
umount -a -t cifs -l
}

EOF
```

2) **Назначим права для управления службой `nas_backup`**
```
chmod +x /etc/init.d/nas_backup
````

3) Активируем службу `nas_backup`
```
/etc/init.d/nas_backup enable
```

4) Запустим службу `nas_backup`
```
/etc/init.d/nas_backup start
```

4) Проверяем подключение. Если все сделано верно, то мы увидим подключенный диск //192.168.1.50/BackUP/Gateway
```
df -h
```
