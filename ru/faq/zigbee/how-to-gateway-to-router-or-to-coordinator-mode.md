#Как шлюз перевести в режим роутера или в режим координатора?

Пока нет полной информации. Если кто-то из вас уже это делал, просьба поделиться своим опытом, и если можно, поделиться инструкцией. Сообщить мне об этом в чате https://t.me/smart_home_divan



# Переводим шлюз в режим роутера

**1)** Скачиваем прошивку LumiRouter.bin
```
wget https://github.com/igo-r/Lumi-Router-JN5169/releases/latest/download/LumiRouter_20210320.bin -O /tmp/LumiRouter.bin 

``` 

**2)** Установим прошивку
```
jnflash /tmp/LumiRouter.bin
```

**3)** Спариваем шлюз с координатором

**a)** Можно сделать либо через консоль

```
jntool erase_pdm
```

**b)** Либо через LuCI. System => Zigbee Tools => Set router mode
![image](https://user-images.githubusercontent.com/64090632/158023933-878e4199-3b7e-4938-a85d-bda8fca3ee85.png)
![image](https://user-images.githubusercontent.com/64090632/158023986-ac7fd6a2-b1f4-4302-9a42-eb1aceac99e2.png)
![image](https://user-images.githubusercontent.com/64090632/158023996-5b860adf-f931-4aa2-917f-e71ebabfc335.png)

**4)** На шлюзе-координатор должен появиться шлюз-роутер

# Источники
[Lumi-Router-JN5169](https://github.com/igo-r/Lumi-Router-JN5169)
