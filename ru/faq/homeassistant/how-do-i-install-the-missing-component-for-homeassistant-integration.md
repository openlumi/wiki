# Как установить недостающий компонент для интеграции Home Assistant?

## Вступление

Установка зависимых пакетов процедура не сложная, но требует понимания, а также обязательно нужно посещать сайт [pypi.org](https://pypi.org) для уточнения. Не все пакеты ставятся через консоль `pip install` и некоторые пакеты требуют предварительно скомпилированные библиотеки, такие пакеты ставятся через LuCI, через менеджер пакетов. Некоторые интеграции нужно расскомментировать через config_flows.py. Также интеграции можно закидывать в папку `custom_components`, туда же будут закидываться пользовательские интеграции



## Инструкция

> **Внимание! В самом низу вы можете посмотреть видео инструкцию по установке flux_led. Принцип установки точно такой же как и в текстовой инструкции. Данная видео инструкция может помочь вам лучше понять как ставить недостающий компонент для интеграции Home Assistant.**

1) Сперва вы должны знать версию установленного Home Assistant, если вы не знаете какая у вас стоит версия Home Assistant, то посмотреть версию можно перейти
* По адресу http://ip:8123/config/info
* Настройки => О системе

***

2) [Скачайте архивный файл](https://github.com/home-assistant/core/tags) соответствующий вашей версии Home Assistant и распакуйте из архива папку `components`. Полный путь к папке `core-год.месяц.число.zip\core-год.месяц.число\homeassistant\components\`

***

3) Находим в папке `components` нужную нам интеграцию и копируем в `/usr/lib/python3.9/site-packages/homeassistant-2021.11.2-py3.9.egg/homeassistant/components`, где `homeassistant-2021.11.2-py3.9.egg` это версия вашего Home Assistant.

> Для понимания ниже приведу примеры
> * Если у вас стоит Home Assistant версии `2021.09.1`, то здесь будет `homeassistant-2021.09.1-py3.9.egg`
> * Если у вас стоит Home Assistant версии `2021.10.5`, то здесь будет `homeassistant-2021.10.5-py3.9.egg`
> * Если у вас стоит Home Assistant версии `2021.11.0`, то здесь будет `homeassistant-2021.11.0-py3.9.egg`

***

4) Проверяем файлик config_flows.py. Файлик config_flows.py находится по адресу `/usr/lib/python3.9/site-packages/homeassistant-2021.11.2-py3.9.egg/homeassistant/generated/config_flows.py`, где `homeassistant-2021.11.2-py3.9.egg` это версия вашего Home Assistant.

> Для понимания ниже приведу примеры
> * Если у вас стоит Home Assistant версии `2021.09.1`, то здесь будет `homeassistant-2021.09.1-py3.9.egg`
> * Если у вас стоит Home Assistant версии `2021.10.5`, то здесь будет `homeassistant-2021.10.5-py3.9.egg`
> * Если у вас стоит Home Assistant версии `2021.11.0`, то здесь будет `homeassistant-2021.11.0-py3.9.egg`

В файлике config_flows.py есть список интеграции, все они закомментированы. Сделано это специально для экономии места на шлюзе. Найдите из списка нужную интеграцию и расскомментируйте ее, а после сохраните изменение

***

5) Также, в каждой интеграции, которые находятся в папке `components` есть файл manifest.json (манифест), где содержится полезная информация

**Пример интеграции Mobile App**

Открываем manifest.json интеграции Mobile App и ищем строчку requirements. В requirements указываются требуемые пакеты `["PyNaCl==1.4.0", "emoji==1.5.0"]`
```
{
  "domain": "mobile_app",
  "name": "Mobile App",
  "config_flow": true,
  "documentation": "https://www.home-assistant.io/integrations/mobile_app",
  "requirements": ["PyNaCl==1.4.0", "emoji==1.5.0"],
  "dependencies": ["http", "webhook", "person", "tag", "websocket_api"],
  "after_dependencies": ["cloud", "camera", "notify"],
  "codeowners": ["@robbiet480"],
  "quality_scale": "internal",
  "iot_class": "local_push"
}
```
Делаем проверку зависимых пакетов командой `pip show PyNaCl emoji`. Версии пакетов не указываем, всегда указываем без версии.
Если пакеты не установлены, то будет сообщение, что таких пакетов нет, значит, значит надо установить эти пакеты с указанием версии как в manifest.json, но есть пакеты, которые надо ставить через LuCI. Чтобы понять,  нужно открыть сайт [pypi.org](https://pypi.org) и в поиск вставить имя пакета, в нашем случае [PyNaCl](https://pypi.org/project/PyNaCl/). Всегда надо читать про любой пакет на этом [сайте](https://pypi.org). Указали нужный пакет и читаете что за пакет. Пакет PyNaCl - это привязка Python к libsodium, которая является ответвлением библиотеки Networking and Cryptography. Поэтому пакет PyNaCl будем ставить через LuCI, через пакет менеджеров. Ставим через LuCI `python3-pynacl`

Пакет Emoji написан для Python, поэтому его ставим через консоль
```
pip install emoji==1.5.0
```


***


**Пример интеграции WLED**

Открываем manifest.json интеграции WLED и ищем строчку requirements. В requirements указывается требуемый пакет `wled==0.8.0`

```
{
  "domain": "wled",
  "name": "WLED",
  "config_flow": true,
  "documentation": "https://www.home-assistant.io/integrations/wled",
  "requirements": ["wled==0.8.0"],
  "zeroconf": ["_wled._tcp.local."],
  "codeowners": ["@frenck"],
  "quality_scale": "platinum",
  "iot_class": "local_push"
}
```
Делаем проверку зависимых пакетов командой `pip show wled`. Версии пакетов не указываем, всегда указываем без версии.
Если пакеты не установлены, то будет сообщение, что таких пакетов нет, значит, значит надо установить эти пакеты с указанием версии как в manifest.json
Снова воспользуемся сайтом [pypi.org](https://pypi.org). Пакет [WLED](https://pypi.org/project/wled/) это асинхронный клиент Python для WLED, поэтому его будем ставить через консоль.

```
pip install wled==0.8.0
```

Но, тут есть один нюанс, пакет wled собран в poetry, поэтому, даже, если вы поставите `wled==0.8.0`, то интеграция не запустится, потому что надо до установить зависимый пакет. Ставим вот этот пакет `packaging`
```
pip install packaging
```


***

**Пример интеграции Xiaomi Gateway**

Открываем manifest.json интеграции Xiaomi Gateway и ищем строчку requirements. В requirements указывается требуемый пакет `PyXiaomiGateway==0.13.4`

```
{
  "domain": "xiaomi_aqara",
  "name": "Xiaomi Gateway (Aqara)",
  "config_flow": true,
  "documentation": "https://www.home-assistant.io/integrations/xiaomi_aqara",
  "requirements": ["PyXiaomiGateway==0.13.4"],
  "after_dependencies": ["discovery"],
  "codeowners": ["@danielhiversen", "@syssi"],
  "zeroconf": ["_miio._udp.local."],
  "iot_class": "local_push"
}
```

Делаем проверку зависимых пакетов командой `pip show PyXiaomiGateway`. Версии пакетов не указываем, всегда указываем без версии.
Если пакеты не установлены, то будет сообщение, что таких пакетов нет, значит, значит надо установить эти пакеты с указанием версии как в manifest.json
Снова воспользуемся сайтом [pypi.org](https://pypi.org). Смотрим про пакет [PyXiaomiGateway](https://pypi.org/project/PyXiaomiGateway/), автор тут ничего не указал, поэтому его будем ставить через консоль.

```
pip install PyXiaomiGateway==0.13.4
```

## Дополнительно
Можно создать папку `custom_components` и закинуть туда папки с интеграциями из папки `components`. Важно. Если закинули интеграцию в `custom_components`, то необходимо открыть `config_flows.py`, если там есть данная интеграция, то расскомментируйте ее, а также потребуется установка требуемых пакетов из manifest.json. Читаем **инструкцию** выше или в справочнике: **Как отследить требуемый пакет для интеграции через утилиту htop?**


## Справочник

**Как отследить требуемый пакет для интеграции через утилиту htop?**

Запустите `htop` в консоли (просто указываем htop), а только после этого в Home Assistant запускайте установку интеграции. В утилите `htop` следите за процессом. Нужно смотреть долго и внимательно, нас должна привлечь внимание строка `pip install --quiet`

Пример запуска интеграции WLED через Home Assistant  
![image](https://user-images.githubusercontent.com/64090632/143303268-0ab0addf-3f97-46b7-a347-637dba31845c.png)


Здесь мы видим, что идет попытка установить пакет wled==0.8.0, соответственно, рекомендую остановить Home Assistant через LuCI, System => Startup, чтобы Home Assistant не пытался установить нужный пакет и шлюз при этом не завис. Ставим пакет нужный пакет, запускаем Home Assistant и запускаем интеграцию.

**Как удалить пакет?**

Пакет удаляется такой строчкой кода `pip uninstall` (имя пакета)

Примеры
* Удаляем пакет wled `pip uninstall wled`
* Удаляем пакет PyXiaomiGateway `pip uninstall PyXiaomiGateway`

### Видео инструкция

Кликаем на скриншот и смотрим видео

[![Watch the video](https://user-images.githubusercontent.com/64090632/150529844-7cf1715e-1dc2-46ff-958f-d8906b7024ea.png)](https://user-images.githubusercontent.com/64090632/150529255-52d35e91-b321-4d69-b0a4-e2abf91d900b.mp4)



## Литература
* [pip documentation](https://pip.pypa.io/en/stable/)
* [pip_install](https://pip.pypa.io/en/stable/cli/pip_install/)
* [pip_uninstall](https://pip.pypa.io/en/stable/cli/pip_uninstall/)
