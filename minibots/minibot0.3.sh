# https://null-byte.wonderhowto.com/how-to/easily-detect-cves-with-nmap-scripts-0181925/
# https://github.com/vulnersCom/nmap-vulners.git
# https://github.com/scipag/vulscan.git

# As root
# cd /usr/share/nmap/scripts/
# git clone https://github.com/vulnersCom/nmap-vulners.git
# git clone https://github.com/scipag/vulscan.git
# cd vulscan/utilities/updater/
# chmod +x updateFiles.sh
# ./updateFiles.sh
# Service postgresql start && su msf msfdb init

banner () {
	clear
	echo " "
	echo "Minibot 0.3 - Copyleft("$'\u0254'") 2019 Badbot Corporation. All rigths freed."
	echo " "
	echo " "
}

vuln_scan () {
	echo "Vuln scan:"
	nmap --script vulscan --script-args vulscandb=cve.csv -sV -p 21-23 -T4 -iR 250 -oN nmapvuln.txt #> /dev/null 2>&1
	grep -Eo '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b|CVE-....-....|cve-....-....' nmapvuln.txt | sed '/^[0-9]/N;{/\n[0-9]/D;}' > vuln_hosts.txt
	vuln_hosts=$(grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" vuln_hosts.txt | wc -l | cut -d " " -f1)

	while [ $vuln_hosts -le 10 ]; do
	nmap --script vulscan --script-args vulscandb=cve.csv -sV -p 21-23 -T4 -iR 250 -oN nmapvuln.txt #> /dev/null 2>&1
	grep -Eo '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b|CVE-....-....|cve-....-....' nmapvuln.txt | sed '/^[0-9]/N;{/\n[0-9]/D;}' >> vuln_hosts.txt
        vuln_hosts=$(grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" vuln_hosts.txt | wc -l | cut -d " " -f1)
	echo $vuln_hosts "Vulnerable hosts."
	done
}

checkploits () {
	echo "Checking FTP exploits: "
	msfconsole -x "search -p 21 name:ftp check:yes cve -o checkploits.csv ;\
		exit" > /dev/null 2>&1
        checkline=2
        total_check=$(wc -l checkploits.csv | cut -d " " -f 1)
        while [ $checkline -le $total_check ]; do
                checkploit=$(head -$checkline checkploits.csv | tail -1 | cut -d "," -f 2 | tr -d '"')
                banner
                echo "Checking "$checkploit":"
                msfconsole -x "use $checkploit ;\
                hosts -R  ;\
                check ;\
                exit"
                ((checkline++))
        done

        echo "Checking SSH exploits: "
        msfconsole -x "search -p 22 name:ssh check:yes cve -o checkploits.csv ;\
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

        echo "Checking TELNET exploits: "
        msfconsole -x "search -p 23 name:telnet check:yes cve -o checkploits.csv ;\
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
vuln_scan

grep -Eo "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" vuln_hosts.txt > ip.txt
msfconsole -x "db_nmap -sV -p 21-23 -T4 -iL ip.txt ;\
		exit"
banner
checkploits

#msfconsole -x "hosts -d ;\
#	services -d ;\
#	exit"
#rm nmapvuln.txt vuln_hosts.txt checkploits.csv
done
