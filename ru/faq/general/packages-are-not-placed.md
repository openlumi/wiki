# У меня не ставятся пакеты или установились не все пакеты

### Если наблюдаете проблемы с установкой пакетов и что-то не установилось, то выяснить это можно, записав установку в лог. Файлик с логами "basic_installation.log" будет находиться в папке /mnt.


***


### Есть два способа мониторить установку в реальном времени, через одну консоль или через две

**Вариант 1. Вывод информации через одну консоль**

```
wget https://raw.githubusercontent.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/main/scripts/initial_installation_for_openwrt.sh -O - | sh 2>&1 | tee /mnt/basic_installation.log 
```

***

**Вариант 2. Вывод информации через две консоли**

Запускаем на первой консоли
```
wget https://raw.githubusercontent.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/main/scripts/initial_installation_for_openwrt.sh -O - | sh > /mnt/basic_installation.log 2>&1
```

Запускаем на второй консоли
```
tail -f /mnt/basic_installation.log 2>&1
```

***

### Возможные варианты, почему не ставятся пакеты. Случаи были взяты с чата [Xiaomi Gateway hack](https://t.me/xiaomi_gw_hack) и будут дополняться
* Нет фидов, нужно добавить фиды. Читаем [здесь](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/wiki/При-установке-базовых-пакетов-возникают-ошибки)
* Переключиться на другого провайдера, если есть возможность. Есть вероятность, что часть сетей у вашего провайдера забанено РКН.
* Подключиться к другому роутеру

