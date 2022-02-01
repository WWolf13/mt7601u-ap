# mt7601u-ap

AP driver for MT7601U chipset based adapters.

В ядре начиная с 4.0 уже есть драйвер для данного чипа, но он только для работы как клиента, а не точки доступа.
Этот драйвер переводит адаптер в режим точки доступа.

### Сборка
```sh
$ git clone https://github.com/WWolf13/mt7601u-ap.git
$ cd mt7601u-ap
$ make
$ sudo make install
$ sudo modprobe mt7601Uap
```

### Настройки
Если модуль загружен, то запуск `sudo ip link set ra0 up` откроет точку доступа WiFi, к которой вы можете подключиться.
Настройки точки доступа находятся в `/etc/wifi/RT2870AP/RT2870AP.txt`.

### P.S.
Исходный код взят с https://github.com/Anthony96922/mt7601u-ap
