# Установил mosquitto, а подключиться через MQTT Explorer к mqtt не могу



В Mosquito 2.0 и выше теперь нужно настраивать параметры аутентификации, прежде чем клиенты смогут подключиться. В более ранних версиях по умолчанию клиентам разрешалось подключаться без проверки подлинности.

Подробно про authentication methods можете прочитать [здесь](https://mosquitto.org/documentation/authentication-methods/)

Необходимо дописать в файлик mosquitto.conf, находящемся по адресу /etc/mosquitto/mosquitto.conf две строчки. Добавить можно, просто в самом верху

```
listener 1883
allow_anonymous true
```

