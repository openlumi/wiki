# Как настроить lumimqtt?

Для управления подсветкой шлюза необходимо установить lumimqtt. Читаем подробно про lumimqtt [здесь](https://github.com/openlumi/lumimqtt)

Установить пакет lumimqtt через LuCI. Делаем как на скриншоте.
1. Обновить список пакетов
1. В поиске ввести lumimqtt
1. Установить найденный пакет lumimqtt
1. Установить на шлюз mosquitto (lumimqtt будет смотреть на локальный MQTT)

![image](https://user-images.githubusercontent.com/64090632/143296983-40d8fa45-3d78-4faa-9317-1b8f20c0f03e.png)

Создаем файлик lumimqtt.json в папке /etc
```
touch /etc/lumimqtt.json
```

Открываем файлик lumimqtt.json c помощью консольного текстового редактора nano. Если nano не стоит - установить nano можно через luCI
```
nano /etc/lumimqtt.json
```

Добавляем в файлик lumimqtt.json
```
{
    "mqtt_host": "localhost",
    "mqtt_port": 1883,
    "mqtt_user": "",
    "mqtt_password": "",
    "topic_root": "lumi/{device_id}",
    "auto_discovery": true,
    "sensor_retain": false,
    "sensor_threshold": 50,
    "sensor_debounce_period": 60,
    "light_transition_period": 1.0
}
```

Перезагружаем шлюз и после в Home Assistant появится управление подсветкой шлюза

![image](https://user-images.githubusercontent.com/64090632/143297030-8f045487-531e-4716-972d-e90b889c3f2d.png)

