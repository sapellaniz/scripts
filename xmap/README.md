# XMAP
Script que lanza un escaneo automatizado con Nmap... y tiene una barra de progreso!!!



Modos de uso:
```
# Escanea todos los puertos por defecto
./xmap.py <IP>

# Escanea los n puertos mas comunes
./xmap.py <IP> <n>
```

El escaneo tiene dos partes:
	1- Detectar puertos abiertos:
```
nmap -Pn -n -T 5 --open
```
	2- Detectar servicios, versiones y lanzar los NSE adecuados a los puertos abiertos.
```
nmap -Pn -sC -sV 
```
