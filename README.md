# Lab10_Wolumeny
## 1. Zawartość Dockerfile

```docker
FROM alpine:latest
RUN apk add --no-cache bash
ADD pluto.sh /
RUN chmod 755 /pluto.sh
VOLUME [/logi]
ENTRYPOINT ["bash", "pluto.sh"]
```

Zawartość pliku pluto.sh

```bash
#!/bin/bash
sleep 60
now=$(date)
mem=$(sed -n "2p" /proc/meminfo)
echo "Data utworzenia: $now" > info.log
echo "Dostepna pamiec: $mem" >> info.log
```

## 2. Zbudowanie obrazu

![Untitled](https://user-images.githubusercontent.com/78736395/170522241-4e1b9970-40a8-4f12-b682-5be259944857.png)

## 3. Utworzenie wolumenu

![Untitled](https://user-images.githubusercontent.com/78736395/170522456-13cc4daa-3952-4578-8b0c-f3ab35aa5054.png)

Wolumen RemoteVol został utworzony na podstawie sterownika local oraz wykorzystuje CIFS dla udostępniania plików, ponieważ systemem macierzystym jest Windows.

![Untitled](https://user-images.githubusercontent.com/78736395/170522536-56e5a1df-7823-4353-af27-6f0a8d9543d2.png)

Wynik polecenia pokazującego listę utworzonych wolumenów, wśród których jest ostatnio utworzony RemoteVol.

## 4. Uruchomienie kontenera

Wynik uruchomienia kontenera

![Untitled](https://user-images.githubusercontent.com/78736395/170524142-eedbd3da-0875-4a61-93ab-b71e959d0def.png)
![Untitled](https://user-images.githubusercontent.com/78736395/170522815-d21a32bf-a7c4-4d5c-827b-06be570d3623.png)

## 5. Potwierdzenie poprawności wykonania zadania

Wynik działania polecenia docker inspect alpine10

![Untitled](https://user-images.githubusercontent.com/78736395/170522960-daced5c1-f2db-419c-8137-6f3853172176.png)

Potwierdzenie uruchomienia skryptu pluto.sh

![Untitled](https://user-images.githubusercontent.com/78736395/170523071-b7969f02-4821-4e86-8948-311c45453ce9.png)

na zrzucie widać, że kontener zakończył działanie z wynikiem 0, czyli poprawnie oraz czas działania tego kontenera był 1 minuta, czyli czas wykonywania skryptu pluto.sh

Potwierdzenie ograniczoności pamięci RAM w kontenerze

![Untitled](https://user-images.githubusercontent.com/78736395/170523188-40e3688a-9f4e-4c8e-991b-f77497e482fe.png)

Wynil polecenia docker stats alpine10

![Untitled](https://user-images.githubusercontent.com/78736395/170523400-84992407-85b5-4f29-a5da-db8595c1903c.png)

Po wymiku tego polecenia już lepiej widać ograniczenie kontenera po wykorzystaniu pamięci RAM oraz to, że podczas działania kontenera było wysłano 656B danych poprzez interfejs sieciowy kontenera. Zatem można powiedzieć, że skrypt [pluto.sh](http://pluto.sh) wykonał się poprawnie i dane były przesłane do systemu macierzystego.

## 6. Sprawdzenie poprawności wykonania zadania za pomocą narzędzia cAdvisor

Polecenie do uruchomienia narzędzia oraz wynik jego działania

```docker
docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor
```

![Untitled](https://user-images.githubusercontent.com/78736395/170523523-dbd7746f-ce1d-4584-a6c2-2886a9d3c865.png)

Potwierdzenie ograniczenia pamięcia dla kontenera do 512MB

![Untitled](https://user-images.githubusercontent.com/78736395/170523634-fc00282e-885c-4d74-a055-73090628a11e.png)

Wynik zapisania danych na systemie macierzystym poprzez sieć

![Untitled](https://user-images.githubusercontent.com/78736395/170523729-40f84ab6-eb28-4d63-b5c7-1182befa0b4d.png)
