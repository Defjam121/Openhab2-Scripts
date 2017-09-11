#!/bin/sh

PID=`ps aux --sort=start_time | grep openhab.*java | grep -v grep | awk '{print $2}' | tail -1`
UP0=`ps -o etimes= -p "${PID}"`
#echo $UPTIME

UP1=$(($UP0/86400))             # Tage
UP2=$(($UP0/3600%24))           # Stunden
UP3=$(($UP0/60%60))             # Minuten
UP4=$(($UP0%60))                # Sekunden

#UPTIME=$(echo $UP2 "Stunde(n)" $UP3 "Minuten")


if [ $UP2 = 0 ]; then
	UPTIME=$(echo $UP3%20"Minuten")
else
	UPTIME=$(echo $UP2%20"Stunden"%20$UP3%20"Minuten")
fi

url_tmp="http://192.168.2.18:8080/classicui/CMD?openHAB_Uptime="${UPTIME}""
echo "$url_tmp"
curl -s $url_tmp > /dev/null 2>&1
