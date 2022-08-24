# Как установить интеграцию HASS Configurator?


> Важно! Home Assistant на шлюзе находится по этому адресу `/etc/homeassistant/`

# HASS Configurator
![image](https://user-images.githubusercontent.com/64090632/143304702-066fde6b-a82c-4d29-b10c-f4ae28feeb06.png)


## Описание
HASS-конфигуратор - это небольшое веб-приложение (вы получаете к нему доступ через веб-браузер), которое предоставляет файловую систему-браузер и текстовый редактор для изменения файлов на компьютере, на котором запущен конфигуратор. Он был создан для того, чтобы упростить настройку домашнего помощника. Он оснащен редактором Ace, который поддерживает подсветку синтаксиса для различных языков кода/разметки. Файлы YAML (язык по умолчанию для файлов конфигурации Home Assistant) будут автоматически проверены на наличие синтаксических ошибок при редактировании.

ВАЖНО: Конфигуратор извлекает библиотеки JavaScript, CSS и шрифты из CDNS. Следовательно, он не работает, когда ваше клиентское устройство находится в автономном режиме. И он доступен только для Python 3.


***
### На выбор вам предлагается установка или удаление интеграции вручную или автоматически с помощью скрипта. Скрипты для авто установки находятся ниже

***


## Установка вручную

1) Установить пакет `hass-configurator`
```
pip install hass-configurator
```

2) Скопировать в папку `components` интеграцию `panel_iframe`. Если не знаете как это сделать, то читаем [Как установить недостающий компонент для интеграции Home Assistant?](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Как-установить-недостающий-компонент-для-интеграции-Home-Assistant%3F)

3) В configuration.yaml `/etc/homeassistant/configuration.yaml` добавить

```
panel_iframe:
  configurator:
    title: Configurator
    icon: mdi:square-edit-outline
    url: http://ip:3218 # указываем IP адрес своего Home Assistant
```

4) Создадим службу `hass-configurator`. Копируем и вставляем код в консоль как есть, после чего в папке /etc/init.d/ появится файлик hass-configurator
```
cat > /etc/init.d/hass-configurator <<EOF
#!/bin/sh /etc/rc.common
START=99
USE_PROCD=1
start_service()
{
    procd_open_instance
    procd_set_param command hass-configurator -b /etc/homeassistant
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}
EOF
```  

5) Назначим права для управления службой `hass-configurator`
```
chmod +x /etc/init.d/hass-configurator
```
6) Активируем службу `hass-configurator`
```
/etc/init.d/hass-configurator enable
```

7) Запустим службу `hass-configurator`
```
/etc/init.d/hass-configurator start
```

8) Перезагружаем Home Assistant
```
/etc/init.d/homeassistant restart
```


## Удаление вручную

Удаляем или комментируем строки в configuration.yaml `/etc/homeassistant/configuration.yaml` и перезагружаем Home Assistant
```
#panel_iframe:
#  configurator:
#    title: Configurator
#    icon: mdi:square-edit-outline
#    url: http://ip:3218 # указываем IP адрес своего Home Assistant
```


Останавливаем службу `hass-configurator`
```
/etc/init.d/hass-configurator stop
```

Удаляем службу `hass-configurator`
```
rm /etc/init.d/hass-configurator
```

Удаляем пакет `hass-configurator`
```
pip uninstall hass-configurator -y
```

***

## Установка автоматически

**Важно!**
> Установка интеграции HASS-конфигуратор будет производиться с помощью скрипта, но в конфигурационный файл configuration.yaml вам придется добавить строки вручную, а также будут два скрипта на удаление интеграции HASS-конфигуратор, где один скрипт не только удаляет интеграцию, но и закомментирует строки для HASS-конфигуратора, а после перезагрузит Home Assistant, а второй скрипт только удаляет интеграцию без вмешательства в configuration.yaml. Вы сами должны удалить из configuration.yaml строки или закомментировать их, а также сами должны перезагрузить Home Assistant

**Установка интеграции HASS-конфигуратор**

**Важно!**
> Если нет интеграции `panel_iframe`, то надо скопировать в папку `components` интеграцию `panel_iframe`. Если не знаете как это сделать, то читаем [Как установить недостающий компонент для интеграции Home Assistant?](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Как-установить-недостающий-компонент-для-интеграции-Home-Assistant%3F)

```
wget https://raw.githubusercontent.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/main/integration/hass_configurator/install_hass_configurator.sh -O - | sh
```

**В configuration.yaml `/etc/homeassistant/configuration.yaml` добавить**
```
panel_iframe:
  configurator:
    title: Configurator
    icon: mdi:square-edit-outline
    url: http://ip:3218 # указываем IP адрес своего Home Assistant

```

***

## Удаление автоматически

**Удаление интеграции HASS-конфигуратор с авто удалением и перезагрузкой Home Assistant**
```
wget https://raw.githubusercontent.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/main/integration/hass_configurator/uninstall_hass_configurator_del_conf_auto.sh -O - | sh
```

**Удаление интеграции HASS-конфигуратор. Удаляете строки в configuration.yaml и перезагружаете вручную Home Assistant**
```
wget  https://raw.githubusercontent.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/main/integration/hass_configurator/uninstall_hass_configurator_del_conf_manual.sh -O - | sh
```
Удаляем или комментируем строки в configuration.yaml `/etc/homeassistant/configuration.yaml` и перезагружаем Home Assistant
```
#panel_iframe:
#  configurator:
#    title: Configurator
#    icon: mdi:square-edit-outline
#    url: http://ip:3218 # указываем IP адрес своего Home Assistant
```


***


## Справочник
**Не открывается HASS Configurator, ошибка "Не удается получить доступ к сайту"**

* Возможно не запущена служба `hass-configurator`. Запустите службу `hass-configurator`
```
/etc/init.d/hass-configurator start
```
* Проверьте в configuration.yaml, не допущена ли ошибка. Верно ли указан IP адрес Home Assistant
* Попробуйте перезагрузить шлюз
* Проверьте, стоит ли пакет hass-configurator
```
pip show hass-configurator
```

**Что делать, если нет интеграции panel_iframe?**

> Надо скопировать в папку components интеграцию panel_iframe. Если не знаете как это сделать, то читаем Как установить недостающий компонент для интеграции Home Assistant?


***

## Источники
* [HASS Configurator](https://github.com/danielperna84/hass-configurator)
* [HASS Configurator WiKi](https://github.com/danielperna84/hass-configurator/wiki/Installation)
* [pip documentation](https://pip.pypa.io/en/stable/user_guide/)
