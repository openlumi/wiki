#Как установить OpenWRT на шлюз?

Смотрим [видеоинструкцию](https://youtu.be/QhVWqDHjWu8)
***

## Справочная информация

<details>
  <summary><b>Как получить root?</b></summary>
  

Читаем [здесь](https://openlumi.github.io/gain_root.html)
  
</details>




<details>
  <summary><b>Что делать, если шлюз зависает на umount: /mnt/.psplash: not mounted?</b></summary>
  

```
umount: /mnt/.psplash: not mounted
INIT: no more processes left in this runlevel
```
![not mounted](https://user-images.githubusercontent.com/64090632/146650397-bcf1c780-455f-4d13-a9c8-e5e6788dd416.jpg)



Перезагружаем шлюз, снова заходим в загрузчик

Заходим в загрузчик
```
setenv bootargs "${bootargs} single rw init=/bin/bash" && boot
```

Вводим эту команду и после перезагружаем шлюз, просто вынимаем из розетки
```
sed -i "s/#mxc0/mxc0/" /etc/inittab
```

Если успех, то после перезагрузки шлюза должна появиться строка запроса ввести логин

![root](https://user-images.githubusercontent.com/64090632/146650426-ee49cbee-d4ff-4fb6-af4a-de4cc62ac714.jpg)
  
</details>


<details>
  <summary><b>Как создать бэкап родной прошивки перед заливкой OpenWRT?</b></summary>


Взято [отсюда](https://openlumi.github.io/#make-a-backup)

У вас должен быть установлен на шлюзе SSH. Подключаемся к шлюза и запускаем консоль. Вводим команду   
```
tar -cvpzf /tmp/lumi_stock.tar.gz -C / . --exclude='./tmp/*' --exclude='./proc/*' --exclude='./sys/*'
```

После создания бэкапа копируем на свой компьютер командой. Запускаем на Windows консоль, вводим пошагово. 

```
cd c:/Temp

scp root@указываем IP адрес вашего шлюза:/tmp/lumi_stock.tar.gz . -y
```
</details>



## Источники

https://openlumi.github.io
