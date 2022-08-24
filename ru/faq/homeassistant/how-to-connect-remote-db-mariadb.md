#Как подключить к Home Assistant удаленную база данных MariaDB

Как вам известно, что Home Assistant пишет в свою базу и использует по умолчанию СУБД LiteSQL. На шлюзе из-за малого количества места, все пишется в память и история хранится 2 дня. Это сильно ограничивает запись истории в базу. Если у нас есть внешний сервер с предустановленной СУБД MariaDB, то можно в конфигурации указать, чтобы Home Assistant писал не во внутреннюю базу, а на внешнюю, но такой способ имеет плюсы и минусы. Плюс в том, что можно писать историю без ограничении и все зависит от объема жесткого диска на внешнем сервере. Минус в том, что если внешний сервер будет недоступен или WiFi будет выключен, то Home Assistant на шлюзе не сможет писать в историю и вероятно просто упадет.

В `/etc/homeassistant/configuration.yaml` есть запись, которая имеется после установки Home Assistant

```
recorder:
  purge_keep_days: 2
  db_url: 'sqlite:///:memory:'
```

***

**Для того, чтобы подключить Home Assistant к внешней СУБД MariaDB, необходимо сделать следующее:**

**1)** Установить через LucI пакет python3-pymysql

**2)** В `/etc/homeassistant/configuration.yaml` изменить строку db_url

```
recorder:
  db_url: 'mysql+pymysql://user:password@SERVER_IP/DB_NAME?charset=utf8mb4'
  purge_keep_days: 2
```

Рекомендуется путь db_url хранить в secrets.yaml

В `/etc/homeassistant/configuration.yaml` указываем таким образом
```
recorder:
  db_url: !secret db_link #URL-адрес, который указывает на вашу базу данных
  purge_keep_days: указываем количество дней
```

в secrets.yaml добавить db_url: 'mysql+pymysql://user:password@SERVER_IP/DB_NAME?charset=utf8mb4'



**3)** Перезагрузить Home Assistant
