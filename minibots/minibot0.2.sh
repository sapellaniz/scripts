# Service postgresql start && su msf msfdb init
banner () {
	clear
	echo " "
	echo "Minibot 0.2 - Copyleft("$'\u0254'") 2019 Badbot Corporation. All rigths freed."
	echo " "
	echo " "
}

port_scan () {
	echo "Port scan:"
	touch services.csv
	while [ "$(wc -l services.csv | cut -d " " -f 1)" -le 26 ]; do
	msfconsole -x "db_nmap -T4 -p 21-23 -iR 250 ;\
			services -u -o services.csv ;\
			exit" > /dev/null 2>&1
	echo "$(tail -n +2 services.csv | wc -l | cut -d " " -f 1) Open ports."
	done
}

checkploits () {
	echo "Checking FTP exploits: "
	msfconsole -x "search check:yes name:ftp port:21 -o checkploits.csv ;\
		exit" > /dev/null 2>&1
        checkline=2
        total_check=$(wc -l checkploits.csv | cut -d " " -f 1)
        while [ $checkline -le $total_check ]; do
                checkploit=$(head -$checkline checkploits.csv | tail -1 | cut -d "," -f 2 | tr -d '"')
                banner
                echo "Checking "$checkploit":"
                msfconsole -x "use $checkploit ;\
                hosts -p 21 -R ;\
                check ;\
                exit"
                ((checkline++))
        done

        echo "Checking SSH exploits: "
        msfconsole -x "search check:yes name:ssh port:22 -o checkploits.csv ;\
                exit" > /dev/null 2>&1
        checkline=2
        total_check=$(wc -l checkploits.csv | cut -d " " -f 1)
        while [ $checkline -le $total_check ]; do
                checkploit=$(head -$checkline checkploits.csv | tail -1 | cut -d "," -f 2 | tr -d '"')
                banner
                echo "Checking "$checkploit":"
                msfconsole -x "use $checkploit ;\
                hosts -p 22 -R ;\
                check ;\
                exit"
                ((checkline++))
        done

        echo "Checking TELNET exploits: "
        msfconsole -x "search check:yes name:telnet port:23 -o checkploits.csv ;\
                exit" > /dev/null 2>&1
        checkline=2
        total_check=$(wc -l checkploits.csv | cut -d " " -f 1)
        while [ $checkline -le $total_check ]; do
                checkploit=$(head -$checkline checkploits.csv | tail -1 | cut -d "," -f 2 | tr -d '"')
                banner
                echo "Checking "$checkploit":"
                msfconsole -x "use $checkploit ;\
                hosts -p 23 -R ;\
                check ;\
                exit"
                ((checkline++))
        done

}

while true ; do
banner
port_scan
banner
checkploits

msfconsole -x "hosts -d ;\
	services -d ;\
	exit"
rm services.csv checkploits.csv
done
