# Как установить и настроить mosquitto? Зачем это нужно?

[Стартовая страница WiKi](https://github.com/DivanX10/wiki#readme)

## Зачем это нужно?
Локальный MQTT брокер на шлюзе нужен для работы собственных служб, таких как: zigbee2mqtt, lumimqtt, lumi. Все эти службы шлют топики на локальный MQTT брокер, а если есть необходимость пересылать топики на другой сервер, например на второй MQTT брокер, то нужно настроить [MQTT мост](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/MQTT-мост).

**Примечание**

> Не рекомендуется в службах указывать внешний MQTT брокер (стоит не на шлюзе, а на отдельном сервере, например аддон MQTT в Home Assistant). Такой подход неверный. Если по какой-то причине внешний MQTT брокер будет не доступен, то службы на шлюзе не будут работать. Именно по этой причине обязательно нужно поднимать на шлюзе локальный брокер, а пересылкой топиков будет заниматься [MQTT мост](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/MQTT-мост).



## Как установить и настроить mosquitto на OpenWRT?
Установить пакет mosquitto через LuCI. Делаем как на скриншоте.

1. Обновить список пакетов
1. В поиске ввести mosquitto
1. Установить на выбор найденный пакет mosquitto
>   * mosquitto-nossl (без поддержки SSL)
>   * mosquitto-ssl (обеспечивает поддержку SSL для зашифрованных сетевых подключений и аутентификации. Требуется использовать сертификат). Подробнее про mosquitto-ssl читаем [здесь](https://mosquitto.org/man/mosquitto-tls-7.html)

![image](https://user-images.githubusercontent.com/64090632/143299517-4ea4e58e-8930-4718-85c2-71db66499aad.png)


После установки mosquitto, в папке /etc появится папка mosquitto, где есть конфигурационный файлик mosquitto.conf. 

По умолчанию доступ из внешних клиентов MQTT к MQTT брокеру на шлюзе будет закрыт из соображении безопасности. Доступ будет только внутри шлюза, т.е внутренние службы, такие как zigbee2mqtt, lumimqtt, home assistant будут иметь доступ к MQTT брокеру, а внешние клиенты - нет. Вот что пишется в [официальной документации](https://mosquitto.org/documentation/authentication-methods/)
> В Mosquito 2.0 и выше теперь нужно настраивать параметры аутентификации, прежде чем клиенты смогут подключиться. В более ранних версиях по умолчанию клиентам разрешалось подключаться без проверки подлинности.

Чтобы получить доступ к MQTT, необходимо добавить две строчки. Добавить можно в самом верху. 
```
listener 1883
allow_anonymous true
```

## Как включить авторизацию?

Чтобы включить авторизацию в mosquitto, необходимо добавить следующие строки в конфигурационный файлик `mosquitto.conf`
> **Важно! Если у вас, при включенной авторизации и включенным MQTT мостом возникли проблемы при подключении к внешнему MQTT брокеру, например в логах аддона MQTT Home Assistant фиксируются цикличные логи connect и disconnect, то выключите авторизацию и предоставьте доступ для всех `allow_anonymous true` и закомментируйте `#password_file /etc/mosquitto/passwordfile`.**

Закрываем доступ для всех, доступ только с пароля 
```
allow_anonymous false
```

Включаем авторизацию. Указываем путь к файлику `passwordfile`, в котором хранятся логин и пароль
```
password_file /etc/mosquitto/passwordfile
```

Создаем файлик `passwordfile`
```
touch /etc/mosquitto/passwordfile
```
В файлик `passwordfile` добавить логин и пароль в таком виде `логин:пароль`
```
mqtt:123456
```