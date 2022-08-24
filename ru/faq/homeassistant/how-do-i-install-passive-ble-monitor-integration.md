# Как установить интеграцию Passive BLE Monitor?

> Важно! Home Assistant на шлюзе находится по этому адресу `/etc/homeassistant/`

### Внимание. Интеграция [Passive BLE Monitor](https://github.com/custom-components/ble_monitor) будет работать только на шлюзе Xiaomi DGNWG05LM со встроенным bluetooth. У Aqara ZHWG11LM нет встроенного bluetooth!


***

1) Остановить службу Home Assistant через System => Startup

2) Ставим пакеты через LuCI
* python3-base
* python3-light
* python3-cryptodomex

3) Скачать [Passive BLE Monitor](https://github.com/custom-components/ble_monitor) и скопировать в custom_components
4) Открыть manifest.json и удалить строку pycryptodomex>=3.11.0 , должно получиться как показано ниже. Файл manifest.json находится в /custom-components/ble_monitor. Это нужно для того, чтобы интеграция Passive BLE Monitor не пыталась скачать и установить пакет pycryptodomex, а также это приводит к зависанию шлюза.
```
{
  "domain": "ble_monitor",
  "name": "Passive BLE monitor",
  "config_flow": true,
  "documentation": "https://github.com/custom-components/ble_monitor",
  "issue_tracker": "https://github.com/custom-components/ble_monitor/issues",
  "requirements": [
    "janus>=0.6.2",
    "aioblescan>=0.2.9"
  ],
  "dependencies": [],
  "codeowners": ["@Ernst79", "@Magalex2x14", "@Thrilleratplay"],
  "version": "5.9.1",
  "iot_class": "local_polling"
}
```
5) Через консоль ставим пакеты той версии, как указано в manifest.json. Например на текущий момент в manifest.json указаны версии janus==0.6.2 aioblescan==0.2.9
```
pip install janus==0.6.2 aioblescan==0.2.9
```
6) Проверяем версии установленных пакетов. Версии пакетов должны совпадать, как указано в manifest.json
```
pip show janus aioblescan
```
* janus==0.6.2
* aioblescan==0.2.9

7) В файлик main.conf добавить строчку `AutoEnable=true`. Файлик main.conf находится по адресу /etc/bluetooth
```
sed -i 's/#AutoEnable=false/AutoEnable=true/' /etc/bluetooth/main.conf
```

8) Перезагружаем шлюз командой
```
reboot
```
9) Ждем загрузки Home Assistant и заходим в интеграции, там должна появиться интеграция Passive BLE Monitor



## Справочная информация

**Что делать, если не работает интеграция Passive BLE Monitor?**

> Внимание! Если у вас установлен Home Assistant, то python3-light не удалять для переустановки. Нельзя удалять python3-light и снова ставить. Только переустановка с заменой. Если удалите и установите python3-light другой версии, то Home Assistant не запустится. Ниже есть код как заменить версию python3-light

При установке Home Assistant с 0 ставится пакет python3-light без включенного bluetooth, следовательно, установив интеграцию Passive BLE Monitor, то в логах Home Assistant мы получаем вот такую ошибку `module socket has no attribute AF_BLUETOOTH`. Также можно запустить в консоли `aioblescan`, предварительно установив нужную версию `aioblescan` из манифеста. Если в python3-light включен bluetooth, то запустив `aioblescan` мы увидим найденные девайсы, если в python3-light не включен bluetooth, то при запуске `aioblescan` мы увидим ошибку `module socket has no attribute AF_BLUETOOTH`. Данная ошибка говорит о том, что в питон не включен bluetooth. Как это исправить?

Скачайте пакет [python3-light_3.9.10-2](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/raw/main/packages/python3-light_3.9.10-2_arm_cortex-a9_neon.ipk) в папку tmp и запустите командой, а после того, как переустановите пакет python3-light, перезагрузите шлюз командой `reboot`.

```
opkg install /tmp/python3-light_3.9.10-2_arm_cortex-a9_neon.ipk --force-reinstall
```

***

**Устройства не появляются, что делать?**
* Удалите интеграцию Passive BLE Monitor через GUI Home Assistant, нажав на 3 точки и удалите.
* Перезагрузите Home Assistant, иначе не позволит добавить интеграцию
* Добавьте интеграцию по новой
* Устройства могут быть обнаружены

***

**Перезагрузка служб bluetooth**
```
service bluetooth restart
```

***

**Как добавить перезапуск службы bluetooth в CRON?**

Делается это в Scheduled Tasks. System => Scheduled Tasks. Для удобства можете воспользоваться [CRON генератором](https://crontab.guru)
```
0 3 * * * service bluetoothd restart  
```

***

**Как ввести журналирование в Home Assistant?**

Добавить в configuration.yaml строчку `custom_components.ble_monitor: info`

Примерно будет выглядеть вот так
```
logger:
  default: warn
  logs:
    custom_components.ble_monitor: info
```

***

**Если получили ошибку `Disable scan failed: Input/output error`?**

Сделайте сброс hciconfig двумя способами

Вариант1
```
hciconfig hci0 down
hciconfig hci0 up
```

Вариант 2
```
hciconfig hci0 reset
```

***

**Могу ли установить Passive BLE Monitor версии 7.0.0 и выше?**

Да, можете. Ставите пакеты согласно манифесту и удаляете из строки манифеста pycryptodomex. Ставите python3-light_3.9.9, согласно статье **Что делать, если не работает интеграция Passive BLE Monitor?** выше.

***


## Литература
[Passive BLE Monitor integration](https://custom-components.github.io/ble_monitor/)

