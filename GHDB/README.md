# GHDB
4447 google dorks
Downloaded from https://www.exploit-db.com/google-hacking-database

```                                                                                                                     test.sh                                                                                                                                         
#!/bin/bash
for i in $(seq 30 1 5784); do
  curl -s https://www.exploit-db.com/ghdb/$i | grep -E "allintitle:|allintext:|blogurl:|cache:|define:|filetype:|intitle:|inurl:|inanchor:|loc:|location:|movie:|related:|site:|source:|stocks:|weather:" | grep -vE "<|>" | tr -d " " | sort -u >> ghdb
  echo -ne "Looking at https://www.exploit-db.com/ghdb/" ;echo -ne $i; echo -ne "\r"
done
```
