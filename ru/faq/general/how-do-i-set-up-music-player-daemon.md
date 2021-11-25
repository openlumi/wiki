# Как настроить Music Player Daemon?

Можете посмотреть [видеомануал](https://youtu.be/ur4laA1UsbI) на моем канале "Умный дом с Диваном"


# Установка

**Установить пакет mpd-full через LuCI. Делаем как на скриншоте**
1. Обновить список пакетов
1. В поиске ввести mpd-full
1. Установить найденный пакет mpd-full 

![MPD](https://github.com/DivanX10/Openwrt-scripts-for-gateway-zhwg11lm/blob/main/image/install%20full-mpd.jpg)

**Конфигурационный файлик mpd.conf, который находится по пути /etc привести в такой вид**
> Важно! По умолчанию в конфиге mpd.conf прописаны базовые настройки, которые нам не нужны, но рекомендую сохранить оригинальный mpd.conf в бэкап и после удалить из него все. Внутри файлика mpd.conf должно быть все пусто, только после этого вставляйте этот код. Почему так рекомендую? Потому что, если не закомментировать в mpd.conf настройки по умолчанию, то при добавлении рабочего параметра в mpd.conf, MDP клиент может не заработать.

```
state_file			"/etc/mpd.state" # Читаем примечание внизу "Как настроить MPD, чтобы сохранял уровень громкости?"
music_directory			"/mpd/music" # Указываем путь к папке music, в моем случае папка mpd находится в корне
playlist_directory		"/mpd/playlists" # Указываем путь к папке playlists, в моем случае папка mpd находится в корне
db_file 			"/mpd/database" # Указываем путь к базе database, в моем случае папка mpd находится в корне
#log_file			"/mpd/log" # Раскомментировать строку, если хотите писать в лог
#log_level			"default" # Раскомментировать строку, если хотите писать в лог
bind_to_address			"any"
port				"6600"
user				"root"
group				"root"
auto_update			"yes"
auto_update_depth		"3"
filesystem_charset		"UTF-8"
id3v1_encoding			"UTF-8"
audio_output {
  type				"alsa"
  name				"My ALSA Device"
  device			"hw:0,0"
  mixer_type			"software"
  mixer_control			"Master"
  mixer_device			"default"
}

```

## Справочная информация

### Можно ли указать другие пути?
> Можно. Все зависит от того, где у вас расположена папка mpd. Вы можете создать папку mpd в любом месте, тогда нужно указать полный путь к папке. Например вы решили создать папку mpd в папке homeassistant, тогда указываем путь таким образом 

```
music_directory			"/etc/homeassistant/mpd/music" 
playlist_directory		"/etc/homeassistant/mpd/playlists" 
db_file 			"/etc/homeassistant/mpd/database"
log_file			"/etc/homeassistant/mpd/log"
```

***

### Как настроить MPD, чтобы сохранял уровень громкости?
> 1. Создать файлик mpd.state через консоль, командой

```
touch /etc/mpd.state
```

> 2. В конфиг mpd.conf добавить строчку 
```
state_file "/etc/mpd.state" (пример конфига выше)
```

***

### Как открыть микшер MPD?
> Вызвать микшер MPD через консоль, командой

```
alsamixer
```

***

### Где взять базу database?
> Базу database создаем вручную

```
touch /mpd/database
```
### Нет файлика log
> 1. Раскомментировать строки 

```
#log_file 
#log_level
```

> 2. Если файлик log не создался после расскоментирования строки, то создаем вручную командой

```
touch /mpd/log
```

### Как добавить в Home Assistant на шлюзе?
Добавить configuration.yaml следующие строки

```
media_player:
  - platform: mpd
    name: "укажите любое имя"
    host: localhost
    port: 6600
```

### Как добавить в Home Assistant не на шлюзе?
Добавить configuration.yaml следующие строки

```
media_player:
  - platform: mpd
    name: "укажите любое имя"
    host: укажите ip адрес шлюза
    port: 6600
```

### Как с Home Assistant запустить аудиофайл?
Не важно где стоит у вас Home Assistant, на шлюзе или на сервере или на Raspberry, если MPD настроен верно, то вам достаточно указать как на примере ниже 

```
service: media_player.play_media
target:
  entity_id: media_player.aqara_gateway_01
data:
  media_content_type: music
  media_content_id: notification_washing_finished_alena.mp3
```

### Как можно проверить работу MPD?
Установите [MPD клиент Auremo для Windows](https://code.google.com/archive/p/auremo/) на Windows. В настройках укажите IP адрес шлюза и если настроено верно, то MPD клиент подключится и будет работать.



***

# Источники
* [Music Player Daemon](https://www.home-assistant.io/integrations/mpd/)
* [Скачать MPD клиент Auremo для Windows](https://code.google.com/archive/p/auremo/)
