---

categories:
- mqtt
- use-cases
- troubleshooting

software:
- mosquitto
---
# Установил mosquitto, а подключиться через MQTT Explorer к mqtt не могу

В Mosquito 2.0 и выше теперь нужно настраивать параметры аутентификации, прежде чем клиенты смогут подключиться. В более ранних версиях по умолчанию клиентам разрешалось подключаться без проверки подлинности.

Подробно про authentication methods можете прочитать [здесь](https://mosquitto.org/documentation/authentication-methods/) и в самой статье wiki [Как установить и настроить mosquitto? Зачем это нужно?](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/Как-установить-и-настроить-mosquitto%3F-Зачем-это-нужно%3F#Как-включить-авторизацию)

Необходимо дописать в файлик mosquitto.conf, находящемся по адресу /etc/mosquitto/mosquitto.conf две строчки. Добавить можно, просто в самом верху

```
listener 1883
allow_anonymous true
```

