#Компиляция пакетов для OpenWRT

## Описание
OpenWRT обновляется и пакеты со временем устаревают. Не все пакеты своевременно обновляются и все зависит от сообщества. Что делать, если пакет устарел и программа перестала работать должным образом, так как требуется пакет нужной версии? Для этого существует система сборки Buildroot, которая позволяет скомпилировать нужный пакет с нужной версией.

> **Важно!**
 
> **1)** Инструкция в процессе написания и будет еще многократно редактироваться. Если видите, что тут написано неправильно, то сообщите мне. Пришлите ваш вариант инструкции. Можете скопировать тут инструкцию и указать что надо исправить и скинуть мне исправленный вариант, а я внесу исправления.

> **2)** Ставить и сбирать пакеты в OpenWrt Buildroot нужно под обычным пользователем (не под суперпользователем, non-root)

***


# Подготовка Ubuntu перед установкой OpenWrt Buildroot
* В зависимости от того, какую ОС семейства Linux вы используете, установите Buildroot согласно этой [инструкции](https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem)

* Для удобства я буду использовать Ubuntu server 20.04 LTS. Скачать образ [Ubuntu server 20.04 LTS](https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso)



**1)** Ставим необходимые пакеты для разворачивания OpenWrt Buildroot на Ubuntu server 20.04 LTS через консоль

```
sudo apt update
sudo apt install build-essential ccache ecj fastjar file g++ gawk \
gettext git java-propose-classpath libelf-dev libncurses5-dev \
libncursesw5-dev libssl-dev python python2.7-dev python3 unzip wget \
python3-distutils python3-setuptools python3-dev rsync subversion \
swig time xsltproc zlib1g-dev 
```

**2)** Ставим пакеты Midnight Commander (MC), nano и FTP сервер.
* Midnight Commander - файловый менеджер, мне удобно работать с файлами и не нужно использовать консоль с командами
* Nano - текстовый редактор
* FTP сервер - откроем доступ к скомпилированным пакетам

```
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install mc nano vsftpd -y
```

**3)** Настроим FTP сервер, чтобы у нас был доступ к пакетам

**1)** Отредактируем файл конфигурации vsftpd. для удобства я его просто удаляю и создаю новый и вставляю свои параметры
```
sudo rm -f /etc/vsftpd.conf && sudo nano /etc/vsftpd.conf
```

**2)** добавим эти параметры
```
listen=YES
listen_ipv6=NO
anonymous_enable=YES
local_enable=YES
write_enable=YES
pam_service_name=vsftpd
connect_from_port_20=YES
```

**3)** Перезагрузим службу FTP
sudo service vsftpd restart

**4)** Проверяем подключение по FTP к Ubuntu Server. Я подключаюсь к Ubuntu Server через Total CMD

![image](https://user-images.githubusercontent.com/64090632/149769226-6b7222d3-1567-43ca-9d2e-db40f2e99292.png)


# Установка OpenWrt Buildroot

**1)** Cкачиваем исходники в домашнюю папку. Версия openwrt может меняться, поэтому, рекомендую зайти на страницу openwrt с [архивами](https://github.com/openlumi/openwrt/releases) и скопировать ссылку на нужный архив.



<details>
  <summary><b>Скриншоты</b></summary>
  

![image](https://user-images.githubusercontent.com/64090632/149811976-bed96b08-479b-407b-8efc-01904e941433.png)
![image](https://user-images.githubusercontent.com/64090632/149812056-6a65cbf0-8320-44a3-9241-1eef76b21193.png)
  
</details>
 

На текущий момент, это openwrt версии v21.02.2-20220218, обращайте внимание на ссылки, где указана версия openwrt

```
wget https://github.com/openlumi/openwrt/archive/refs/tags/v21.02.2-20220218.tar.gz -O ~/v21.02.2-20220218.tar.gz
```

**2)** Разархивируем архив v21.02.1-20211002.tar.g в домашней папке и сразу же переименуем папку openwrt-21.02.1-20211002 в openwrt

```
tar xvzf v21.02.2-20220218.tar.gz && mv openwrt-21.02.2-20220218 openwrt
```

**3)** Перейдем в папку openwrt которая находится в домашней папке

```
cd ~/openwrt
```

**4)** Открываем папку openwrt и копируем файлик с переименованием(согласно какой у нас шлюз) config_xiaomi_dgnwg05lm или aqara_zhwg11lm
 в `.config`. Выделяю нужный файл(у меня шлюз XIAOMI DGNWG05LM, следовательно выбираю файл `config_xiaomi_dgnwg05lm` и копирую его с переименованием. Выбираю файл `config_xiaomi_dgnwg05lm`=> Файл => Копировать. В этих файлах находятся готовые надстройки для шлюза и нам не потребуется вручную делать настройки для шлюза.
> Важно! Не удаляйте оригинальные файлы config_xiaomi_dgnwg05lm или aqara_zhwg11lm, просто копируйте с переименованием в `.config`. После переименования надо обязательно сделать make (def|menu)config, иначе не соберётся

Переименовываем и копируем через консоль, а после применяем стандартные параметры для профиля

```
cp config_xiaomi_dgnwg05lm .config && make -j$(nproc) defconfig
```

<details>
  <summary><b>Для понимания и для сравнения, зачем  это делается</b></summary>
  

**а)** Без копирования и переименования config_xiaomi_dgnwg05lm или aqara_zhwg11lm. Здесь нет нашего шлюза и нужно настраивать вручную
![image](https://user-images.githubusercontent.com/64090632/149775540-451cd874-e414-47ca-87bc-f8bac12fe8ef.png)

**b)** Копируем и переименовываем config_xiaomi_dgnwg05lm или aqara_zhwg11lm в `.config`. Здесь есть настройки для нашего шлюза и настраивать ничего не нужно

![image](https://user-images.githubusercontent.com/64090632/149775940-c827e304-e66e-4633-bcfe-59f4189afd1d.png)
  
</details>



**5)** Добавим фиды в feeds.conf.default

```
nano feeds.conf.default
```

Меняем содержимое в feeds.conf.default с

 > Примечание! Символ ^ означает, что это указание на конкретный коммит, а ; это указание на ветку, а ветки смотреть на картинке

```
src-git packages https://git.openwrt.org/feed/packages.git^ded142471e36831d2af63c7fe5062c4367f8ccd2
src-git luci https://git.openwrt.org/project/luci.git^d24760e60a83b63f316c7b186e30636b5baa5481
src-git routing https://git.openwrt.org/feed/routing.git^9e7698f20d1edf8f912fbce2f21400f3cc772b31
src-git telephony https://git.openwrt.org/feed/telephony.git^ed2719867150a9bfc85bf41dff52ef8443820f2a
```

на и указываем версию openwrt-21.02, чтобы загрузились пакеты только для openwrt-21.02

```
src-git packages https://git.openwrt.org/feed/packages.git;openwrt-21.02
src-git luci https://git.openwrt.org/project/luci.git;openwrt-21.02
src-git routing https://git.openwrt.org/feed/routing.git;openwrt-21.02
src-git telephony https://git.openwrt.org/feed/telephony.git;openwrt-21.02
```

Для удобства я просто закомментировал ссылки и добавил нужные

![image](https://user-images.githubusercontent.com/64090632/149777188-af6a3603-dfab-45a5-b4a4-f892b910a3fa.png)


Для понимания, перейдите по ссылке,  которая указана в фиде https://git.openwrt.org/feed/packages.git и откроется страница, где ниже будут разные версии openwrt, чтобы не загрузились пакеты всех версии, мы указываем конкретную версию openwrt-21.02

![image](https://user-images.githubusercontent.com/64090632/149776703-ec926b3f-8825-4520-ae4a-4f193d293fb3.png)


**6)** Обновление репозитория

```
./scripts/feeds update -a
```

**7)** Установим пакеты. Установка пакетов в нескольких вариантов

**a)** Загрузим все имеющиеся пакеты для дальнейшего выбора, для компиляции

```
./scripts/feeds install -a
```


**b)** Если не хотите загружать полный список пакетов, а только индивидуальные пакеты

```
./scripts/feeds install <PACKAGENAME>
```

Например нам нужно добавить и собрать эти пакеты `python3` и `python3-cryptodomex`
```
./scripts/feeds install python3 python3-cryptodomex
```

или нужно добавить один пакет python3-light
```
./scripts/feeds install python3-light
```

**7)** Запустим конфигуратор OpenWrt Buildroot и находим пункт Languages

```
make menuconfig
```

![image](https://user-images.githubusercontent.com/64090632/149780593-9cdb51f9-84b3-48a5-8ca1-962e0b1331cf.png)


**8)** Проваливаемся в Languages и находим пункт Python

![image](https://user-images.githubusercontent.com/64090632/149780791-920ae7da-aa32-45bf-96fb-cd0cb383256a.png)


**9)** Выбираем нужные пакеты и нажимаем на пробел. Например нужно скомпилировать пакет `python3-light` с включенным `bluetooth`. Выбираем пакет `python3-light` нажимаем на пробел и выбираем букву `M`, потом проваливаемся в `Configuration` и ставим `*` напротив `bluetooth`

> Существуют 3 значения: `<*>` / `<M>` / `< >`, которые представлены следующим образом:
> * (нажав `<*>`) Этот пакет будет включен в образ прошивки
> * (нажав `<M>` ) Этот пакет будет скомпилирован (и может быть установлен с помощью opkg после прошивки OpenWrt), но не будет включен в образ прошивки
> * (нажав `< >`) Этот пакет не будет скомпилирован

![image](https://user-images.githubusercontent.com/64090632/149780940-47a16b38-2b98-4355-81d0-b6fb7e81e5b0.png)
![image](https://user-images.githubusercontent.com/64090632/149781548-759ec28a-54ba-4a20-bad4-7284c9349080.png)

**10)** После того, как выбрали нужные пакеты для сборки пакеты, все это нужно сохранить. Выходим в главное меню и нажимаем на `Save` и сохраняем наши настройки.

![image](https://user-images.githubusercontent.com/64090632/149781987-64eca56d-da8d-4cc3-9202-88fea59d7d06.png)


**11)** Сборка пакетов делается в двух вариантах. Полная и частичная сборка пакетов. Сборка пакета занимает приличное время, может длиться от 30 минут до N часов. Все зависит от количества пакетов и мощности машины. 

> Примечание! Процесс сборки можно ускорить запустив несколько параллельных задания с использованием параметра -j

```
make -j 3
```

* Используйте стандартную формулу <количество процессоров + 1>
* Если это приводит к случайным ошибкам сборки запустите компиляцию еще раз, но без параметра -j

> Собранные пакеты находятся в папке **bin**

<details>
  <summary><b>Вариант 1. Сборка образа и пакетов</b></summary>
  


```
make или make world
```

Эта команда вызовет последовательность событий:

* компиляция набора инструментов (toolchain)
* потом кросс-компиляция исходных кодов с этим инструментарием
* создание opkg-пакетов
* создание образа прошивки, готового к прошивке


</details>


<details>
  <summary><b>Вариант 2. Сборка одиночных пакетов</b></summary>


Перед сборкой одиночных пакетов запускаем установку инструментов

```
make tools/install
make toolchain/install
```

или с использованием нескольких ядер для ускорения сборки. Ниже пример для 4-х ядер. 

```
make -j 4 tools/install
make -j 4 toolchain/install
```

> Примечание! Процесс сборки можно ускорить запустив несколько параллельных задания с использованием параметра -j

```
make -j 3
```

* Используйте стандартную формулу <количество процессоров + 1>
* Если это приводит к случайным ошибкам сборки запустите компиляцию еще раз, но без параметра -j


Компилируем пакет

```
make package/python3/compile
```

Пример компилирования пакета с использованием нескольких ядер для ускорения сборки

```
make -j 2 package/python3/compile
```




</details>


***


## Справочная информация

### Очистка
Время от времени вам может понадобиться очистить среду сборки. Следующие параметры `make` подходят для этой цели:

Clean удаляет содержимое каталогов bin и build_dir.

```
make clean
```


Dirclean удаляет содержимое каталогов /bin и /build_dir, а также дополнительно /staging_dir и /toolchain (инструментарий кросс-компиляции). 'Dirclean' - основная команда для полной очистки.

```
make dirclean
```

Distclean удаляет все что вы собрали или настроили, а также удаляет все загруженное из репозитория и исходные коды пакетов.

```
make distclean
```

> Важно! Кроме всего прочего будет стерта ваша конфигурация сборки (.config), ваш набор инструментов (toolchain) и все прочие исходные коды. Используйте с осторожностью!




## Литература

* [OpenWrt Buildroot – Использование](https://openwrt.org/ru/doc/howto/build)
* [Using the SDK](https://openwrt.org/docs/guide-developer/toolchain/using_the_sdk)
* [Build system setup](https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem)
* [Сборка одиночных пакетов](https://openwrt.org/docs/guide-developer/toolchain/single.package)
* [Исходники ubuntu](https://releases.ubuntu.com/20.04/)


