# MINIBOTS
Scripts diseñados para barrer Internet en busca de servicios vulnerables con el fin de informar a sus administradores.

Cada nueva version mejora exponencialmente la eficiencia por lo que todas excepto la última se consideran obsoletas.

Los exploits lanzados solo comprueban si las máquinas son vulnerables y en ningun caso explotan dichas vulnerabilidades ni afectan el correcto funcionamiento de sus servicios.

## Minibot 0.4
Escanea IP aleatorias para descubrir servicios vulnerables(según vulscan) a la escucha en los puertos especificados, descarta los servicios filtrados por firewal, IDS/IPS... y comprueba los exploits diseñados para los servicios asociados a dichos puertos. Para mayor eficiencia dispone de una lista negra (blacklist.txt) para evitar direcciones IP inválidas.

https://hub.docker.com/repository/docker/santatecla/minibot0.4 (2.52GB)
```
./minibot0.4.sh -p 22
docker run -it santatecla/minibot0.4:latest -p 22
```

## Minibot 0.3
Escanea IP aleatorias para descubrir servicios vulnerables(según vulscan) a la escucha en los puertos 21-23, comprueba ~45 exploits de Telnet, SSH y FTP con hosts en grupos de más de 10.

https://hub.docker.com/r/santatecla/minibot0.3 (2.51GB)
```
./minibot0.3.sh
docker run -it santatecla/minibot0.3:latest
```

## Minibot 0.2
Escanea IP aleatorias para descubrir servicios a la escucha en los puertos 21-23, comprueba ~45 exploits de Telnet, SSH y FTP con hosts en grupos de más de 25.

https://hub.docker.com/r/santatecla/minibot0.2 (2.2GB)
```
./minibot0.2.sh
docker run -it santatecla/minibot0.2:latest
```

## Minibot 0.1
Escanea IP aleatorias para descubrir Hosts activos, comprueba más de 1.400 exploits con cada host en grupos de más de 25 hosts activos:

https://hub.docker.com/r/santatecla/minibot0.1 (2.2GB)
```
./minibot0.1.sh
docker run -it santatecla/minibot0.1:latest
```
