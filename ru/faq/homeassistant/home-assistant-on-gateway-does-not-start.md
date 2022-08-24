#Home-Assistant на шлюзе не запускается

Если вы столкнулись с тем, что Home Assistant на шлюзе не запускается, то есть несколько причин, отсутствует нужный пакет для интеграции, допущена ошибка в конфигурации Home Assistant или просто не Home Assistant не может самостоятельно запуститься.

### Вариант 1. Отсутствует нужный пакет для интеграции

Читаем [Как установить недостающий компонент для интеграции Home Assistant?](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Как-установить-недостающий-компонент-для-интеграции-Home-Assistant%3F)


***

### Вариант 2. Допущена ошибка в конфигурации Home Assistant

Запускаем в консоли команду `hass` и ждем когда загрузятся логи или ищем логи в папке `/var/log/home-assistant.log`. Смотрим логи и разбираемся в чем допущена ошибка


***

### Вариант 3. Home Assistant не может самостоятельно запуститься

Проверяем, запустится ли Home Assistant, если мы запустим службу homeassistant вручную, если Home Assistant после запуска службы homeassistant заработает, значит проблема в автозагрузке службы и нужно добавить в `/etc/init.d/homeassistant` строку `procd_set_param respawn 3600 5 10`. У Home Assistant с версии 2022 наблюдается проблема с перезапуском и после чего Home Assistant не стартует. Можете почитать подробнее [здесь](https://github.com/home-assistant/core/issues/65450).

**Запуск службы Home Assistant**
```
/etc/init.d/homeassistant start
```

Открываем файл homeassistant, находящийся по пути `/etc/init.d/homeassistant` и приводим к следующему виду.
```
#!/bin/sh /etc/rc.common

START=99
USE_PROCD=1

start_service()
{
    procd_open_instance
    procd_set_param command hass --config /etc/homeassistant --log-file /var/log/home-assistant.log --log-rotate-days 3
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_set_param respawn 3600 5 10
    procd_close_instance
}
```
