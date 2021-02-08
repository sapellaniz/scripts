#!/usr/bin/python3
from time import sleep
from progress.bar import Bar
import os
import sys
import subprocess
import re

def run(cmd):
    proc = subprocess.Popen(cmd,
        stdout = subprocess.PIPE,
        stderr = subprocess.PIPE,                                    
    )
    stdout, stderr = proc.communicate()             
    return proc.returncode, stdout, stderr

# Check args
if (len(sys.argv) == 2 ):
    ports = "-p-"
elif (len(sys.argv) == 3 ):
    ports = "--top-ports "+str(sys.argv[2])
else:
    print("Usage: ./xmap.py <IP> [top-ports]")
    exit()

ip = sys.argv[1]

os.system("echo Starting Nmap \( https://nmap.org \) at $(date '+%F %H:%M %Z')")

# SYN SCAN
cmd = "nmap -Pn -n -T 5 "+ip+" "+ports+" -oX .nmap.tmp --open --stats-every 1 2&>/dev/null &"
os.system(cmd)
sleep(1)

code, out, err = run(["tail", "-n 1", ".nmap.tmp"])

prev = 0
with Bar('SYN scan:   ', suffix='%(percent).1f%%') as bar:
    while(len(format(out)) != 15):
        if(len(format(out).split()[4]) < 20):
            p = format(out).split()[4]
            q = re.search('\"(.+?)\"', p).group(1)
            r = int(float(q))
            nx = r - prev
            prev = r
            bar.next(nx)

        sleep(1)
        code, out, err = run(["tail", "-n 1",  ".nmap.tmp"])
    bar.next(100)

# Extract ports
file = open(".nmap.tmp", "r")
ports = ""

for l in file:
    if re.search("portid", l):
        a = l.split()[2]
        a = re.search('\"(.+?)\"', a).group(1)
        ports = a+","+ports

file.close()

if (ports == "" ):
    print("No open ports found")
    exit()

# NSE & version scan
cmd = "nmap -Pn -sC -sV "+ip+" -p "+ports+" -oX .nmap.tmp -oN targeted --stats-every 1 2&>/dev/null"
os.system(cmd)
sleep(1)

code, out, err = run(["tail", "-n 1", ".nmap.tmp"])

prev = 0
with Bar('NSE scan:   ', suffix='%(percent).1f%%') as bar:
    while(len(format(out)) != 15):
        if(len(format(out).split()[4]) < 20):
            p = format(out).split()[4]
            q = re.search('\"(.+?)\"', p).group(1)
            r = int(float(q))
            nx = r - prev
            prev = r
            bar.next(nx)

        sleep(1)
        code, out, err = run(["tail", "-n 1",  ".nmap.tmp"])
    bar.next(100)

os.remove(".nmap.tmp")
os.system("cat targeted")
