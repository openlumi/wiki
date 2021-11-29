# Network UPS Tools. Мониторинг и управление ИБП

**Network UPS Tools** — это комплекс программ мониторинга и управления различными блоками бесперебойного питания.

Для мониторинга или управления ИБП, необходимо ИБП подключить к ПК или к серверу, т.е подключить к чему либо, что будет выступать сервером для ИБП. У меня ИБП подключен к NAS Synology, а шлюз  и я покажу пример настройки как это настраивается.

> Важно! Ваш ИБП должен поддерживать Network UPS Tools. Список доступных ИБП можно посмотреть [здесь](https://networkupstools.org/stable-hcl.html) или на портале [Synology](https://www.synology.com/ru-ru/compatibility?search_by=category&category=upses&p=1&change_log_p=1)


## Команды для управления ИБП
> Важно! На вашем ИБП спсиок команд может отличаться от данного списка.

* `load.off`                        - (Turn off the load immediately)
* `load.on`                         - (Turn on the load immediately)
* `load.off.delay`                  - (Turn off the load possibly after a delay)
* `load.on.delay`                   - (Turn on the load possibly after a delay)
* `shutdown.return`                 - (Turn off the load possibly after a delay and return when power is back)
* `shutdown.stayoff`                - (Turn off the load possibly after a delay and remain off even if power returns)
* `shutdown.stop`                   - (Stop a shutdown in progress)
* `shutdown.reboot`                 - (Shut down the load briefly while rebooting the UPS)
* `shutdown.reboot.graceful`        - (After a delay, shut down the load briefly while rebooting the UPS)
* `test.panel.start`                - (Start testing the UPS panel)
* `test.panel.stop`                 - (Stop a UPS panel test)
* `test.failure.start`              - (Start a simulated power failure)
* `test.failure.stop`               - (Stop simulating a power failure)
* `test.battery.start`              - (Start a battery test)
* `test.battery.start.quick`        - (Start a "quick" battery test)
* `test.battery.start.deep`         - (Start a "deep" battery test)
* `test.battery.stop`               - (Stop the battery test)
* `calibrate.start`                 - (Запуск калибровки)
* `calibrate.stop`                  - (Остановка калибровки)
* `beeper.disable`                  - (Выключение звукового сигнала)
* `beeper.enable`                   - (Включение звукового сигнала)
* `beeper.mute`                     - (Звуковой сигнал отключен)
* `beeper.off`                      - (Выключение звукового сигнала)
* `beeper.on`                       - (Включение звукового сигнала)
* `bypass.start`
* `bypass.stop`




## Панель управления
Данную карточку для ИБП я создал с использованием двух пользовательских интеграции
* [multiple entity row](https://github.com/benct/lovelace-multiple-entity-row)
* [fold entity row](https://github.com/thomasloven/lovelace-fold-entity-row)


![image](https://user-images.githubusercontent.com/64090632/143938920-71b7df88-6f34-46a8-b82b-7cf7966b98ae.png)

```
type: entities
entities:
  - type: custom:fold-entity-row
    head:
      entity: sensor.ups_cyberpower_livingroom
      name: ИБП
      type: custom:multiple-entity-row
      secondary_info:
        attribute: Уровень заряда
        name: Батарея
        unit: '%'
      state_header: Статус
      entities:
        - entity: group.livingroom_ups
          name: Сенсоры
          icon: mdi:information-outline
        - entity: sensor.ups_load
          name: Нагрузка
        - entity: sensor.ups_load_watts
          name: Нагрузка
    entities:
      - entity: switch.ups_beeper
        secondary_info: last-changed
        icon: mdi:volume-high
      - entity: switch.ups_test_battery_quick
        secondary_info: last-changed
        icon: mdi:battery
      - entity: switch.ups_test_battery_deep
        secondary_info: last-changed
        icon: mdi:battery

```




## Источники
* [Network UPS Tools](https://networkupstools.org)
* [Network UPS Tools Developer Guide](https://networkupstools.org/docs/developer-guide.chunked/index.html)
* [Home Assistant. Network UPS Tools](https://www.home-assistant.io/integrations/nut/)
* [Home Assistant. Command line Switch](https://www.home-assistant.io/integrations/switch.command_line/)
* [Home Assistant. multiple entity row](https://github.com/benct/lovelace-multiple-entity-row)
* [Home Assistant. fold entity row](https://github.com/thomasloven/lovelace-fold-entity-row)
* [Home Assistant. Group](https://www.home-assistant.io/integrations/group/)
