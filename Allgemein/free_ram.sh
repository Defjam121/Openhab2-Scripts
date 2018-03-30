#!/bin/bash
#======================================== ========================================
#
#     FILE:           			free_ram.sh
#     PROJECT:           		Scripte
#     PATH:				C:\Users\march\Google Drive\Scripte\Eigene\openhab2\free_ram.sh
#     AUTHOR:              		HelpiStone
#     EMAIL:                  		helpi9007@gmail.com
#     CREATED:          		12-08-2017
#
#     MODIFIED BY:      		Helpi_Stone
#     MODIFIED DATE:  		12-08-2017
#
#     DESCRIPTION:   		"Free RAM über SSH abfragen"
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

# Verbindung mittels ssh herstellen und Free RAM abfragen
#freemem=$(/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "free -m | awk 'NR==2 {print $4 " MB"}'")


# Verbindung mittels ssh herstellen und Free RAM abfragen
freemem=$(/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "/scripts/ram.sh")

#echo $freemem | awk 'NR==2 {print $4 " MB"}'
echo -e "$freemem"
