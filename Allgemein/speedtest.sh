#!/bin/bash
ping -c1 8.8.8.8 > /dev/null

if [ $? -ne 0 ]; then
        PING=0
        DOWN=0
        UP=0
        IP="Offline"
else
        /scripts/speedtest-cli --simple > /tmp/speedresult.txt
        PING=$(cat /tmp/speedresult.txt |grep Ping |cut -d " " -f 2)
        DOWN=$(cat /tmp/speedresult.txt |grep Download |cut -d " " -f 2)
        UP=$(cat /tmp/speedresult.txt |grep Upload |cut -d " " -f 2)
        IP=$(/usr/bin/curl -s http://ifconfig.me/ip)
fi


/usr/bin/curl -s --header "Content-Type: text/plain" --request POST --data $PING http://marc:Daniel121@192.168.2.13:8080/rest/items/INET_PING
/usr/bin/curl -s --header "Content-Type: text/plain" --request POST --data $DOWN http://marc:Daniel121@192.168.2.13:8080/rest/items/INET_DOWN
/usr/bin/curl -s --header "Content-Type: text/plain" --request POST --data $UP http://marc:Daniel121@192.168.2.13:8080/rest/items/INET_UP
/usr/bin/curl -s --header "Content-Type: text/plain" --request POST --data $IP http://marc:Daniel121@192.168.2.13:8080/rest/items/INET_IP

rm -f /tmp/speedresult.txt
