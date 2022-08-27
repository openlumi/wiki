---

categories:
- general
- use-cases
---
# Подключаем Яндекс диск (Webdav)

Яндекс Диск WebDav – это протокол, позволяющий работать без установки специальной программы. Идеальное решение для тех, кто хочет управлять файлами, не сохраняя копию на компьютер.

Выражаю благодарность @CEBEPYC! и @Clear_Highway за инструкцию и сам замечательный пакет davfs2

> **Важно! Создание полного Backup на Webdav занимает довольно продолжительное время и сопровождается тормозами на самом шлюзе. Если использовать выборочный бэкап, то время создания бэкапа будет быстрее.**

## Установка WebDav

1) **Ставим пакет davfs2 через LuCI. System => Software**

![image](https://user-images.githubusercontent.com/64090632/143297954-947dd2e1-2731-4165-9779-e5f062bea013.png)



***

2) **Заходим в [Яндекс Паспорт](https://passport.yandex.ru/profile) с тем логином, к диску которого хотим подключить шлюз**


"Пароли и авторизация" > "Пароли приложений" > "Создать новый пароль" > "Создать пароль приложения" > "Файлы WebDAW". Пишем толковое и понятное название нового пароля.
> **Важно! Один пароль для одного соединения. Обозвали, "Создать". Вводите пароль от почтового ящика и обязательно копируете выданный пароль куда-то. Он будет работать, но вы его больше не увидите.**

![image](https://user-images.githubusercontent.com/64090632/143298185-a5ab86eb-89ea-41f2-a048-86e294d389ff.png)


***
**3) Теперь копируете следующие команды и меняете в них `login` на логин диска и `password` на выданный выше пароль приложения.**

> Создаем папку yandex_webdav
```
mkdir -p /mnt/yandex_webdav
```

> Создаем файлик secrets, где будут храниться логин и пароль. Впишите вместо `login` и `password` свой логин от яндекс и пароль, который мы получили для приложения
```
cat << "EOF" > /etc/davfs2/secrets
https://webdav.yandex.ru login password
EOF
```

> Присвоим права для файлика secrets
```
chmod 600 /etc/davfs2/secrets
```

> Примонтируем диск yandex_webdav
```
mount.davfs https://webdav.yandex.ru /mnt/yandex_webdav
```

> Проверяем подключение. Если все сделано верно, то мы увидим подключенный диск yandex_webdav
```
df -h
```
![image](https://user-images.githubusercontent.com/64090632/143298078-e11027ca-de9b-430b-8d79-dd826066af1d.png)



## Резервное копирование

Вы можете делать полную копию шлюза или частичное. На ваше усмотрение

**Полный бэкап шлюза**

Создадим папку `backup_gw`
```
mkdir -p /mnt/yandex_webdav/backup_gw
```

Запуск бэкапа
```
tar cvz -f /mnt/yandex_webdav/backup_gw/backup_gw-$(date +%d-%m-20%y_%H-%M).tar.gz -C /overlay/upper/ /overlay/upper/
```

***

При желании можно добавить создание бэкапа в планировщик задач (Cron). System => Scheduled Tasks. Для удобства можете воспользоваться [CRON генератором](https://crontab.guru)

На примере запуск бэкапа в 03:00 часа, ежедневно

```
0 3 * * * tar cvz -f /mnt/yandex_webdav/backup_gw/backup_gw-$(date +%d-%m-20%y_%H-%M).tar.gz -C /overlay/upper/ /overlay/upper/ 

```


***

**Выборочный бэкап**

Данный вариант можно использовать для запуска бэкапа с Home Assistant. Читаем инструкцию [мониторинг папок для бэкапа и не только](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Мониторинг-папок-для-бэкапа-и-не-только)

Создадим папку для скриптов `scripts`
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
* В строке backup вы указываете нужный путь, где будет храниться бэкап
* В строке bkpfolder указываем какие папки нужно бэкапить
* В строке bkpfile указываем какие файлы нужно бэкапить
```
#!/bin/bash
backup="/mnt/yandex_webdav/Gateway/backup_gw-$(date +%Y-%m-%d_%H:%M).tar"

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

## Авто монтирование диска

1) **Создадим файл `webdav_yadisk` который будет в службах**

> **Важно! Диск указывайте тот, который вы монтируете, в моем случае, это /mnt/yandex_webdav**

```
cat << "EOF" > /etc/init.d/webdav_yadisk
#!/bin/sh /etc/rc.common

USE_PROCD=1
START=99
STOP=65

start_service(){
mount.davfs https://webdav.yandex.ru /mnt/yandex_webdav
}

start() {
mount.davfs https://webdav.yandex.ru /mnt/yandex_webdav
}

stop() {
umount /mnt/yandex_webdav
}

EOF
```

2) **Назначим права для управления службой `webdav_yadisk`**
```
chmod +x /etc/init.d/webdav_yadisk
````

3) Активируем службу `webdav_yadisk`
```
/etc/init.d/webdav_yadisk enable
```

4) Запустим службу `webdav_yadisk`
```
/etc/init.d/webdav_yadisk start
```

5) Проверяем, примонтировался ли диск `yandex_webdav`.
> **Важно! Диск указывайте тот, который вы монтируете, в моем случае, это /mnt/yandex_webdav. Если у вас диск имеет другое название, например ya_disk, то указываем /mnt/ya_disk**

```
df -h /mnt/yandex_webdav
```
Если успех, то увидите примонтированный диск `yandex_webdav`

![image](https://user-images.githubusercontent.com/64090632/143298279-0bab79a6-eb8c-4386-b283-d3efbe435f24.png)


***

## Справочная информация

**Как сменить пароль для WebDav?**
> Открываем файлик `secrets`, расположенный по адресу /etc/davfs2/secrets и редактируем пароль





