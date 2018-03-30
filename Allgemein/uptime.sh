#!/bin/bash
#======================================== ========================================
#
#     FILE:           		uptime.sh
#     PROJECT:           		Scripte
#     PATH:			C:\Users\march\Google Drive\Scripte\Eigene\openhab2\uptime.sh
#     AUTHOR:              		HelpiStone
#     EMAIL:                  		helpi9007@gmail.com
#     CREATED:          		14-07-2017
#
#     MODIFIED BY:      	Helpi_Stone
#     MODIFIED DATE:  	19-07-2017
#
#     DESCRIPTION:   		"Fragt die Laufzeit des Servers ab und wandelt die Ausgabe in Deutsch um"
#
#======================================== ========================================
#Pruefen, ob Suffix angegeben
if [ -z "$1" ] ;then
    echo "So geht das nicht"
    exit 1;
fi

#Prüfen, ob Host erreichbar
ping -c 1 192.168.2.$1 &> /dev/null
if [ "$?" != 0 ] ; then
        echo "Offline"
        exit 1;
fi
# Verbindung mittels ssh herstellen und Laufzeit abfragen
up=$(/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "uptime -p")

# Ausgabe von Uptime in Deutsch umwandeln.
echo $up | sed 's/up //g' | sed 's/, / /g' | sed 's/days/Tage/g' | sed 's/day/Tag/g' | sed 's/hours/Stunden/g' | sed 's/hour/Stunde/g' | sed 's/minutes/Minuten/g' | sed 's/minute/Minute/g'

