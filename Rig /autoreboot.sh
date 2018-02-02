#!/bin/bash
###
# Filename:          autoreboot.sh
# Project:           Rig 
# Author:            macbook 
# -----
# File Created:      31-01-2018
# -----
# Last Modified:     31-01-2018
# Modified By:       macbook 
# -----
###

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

# Wert des Sensors auslesen
INPUT=$(/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "show stats | grep autorebooted:| tr -s ' '| cut -d : -f 2")

# Wert ausgeben
echo $INPUT
