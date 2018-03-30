#
# @Author: mikey.zhaopeng 
# @Date: 2018-03-28 10:11:45 
# @Last Modified by:   mikey.zhaopeng 
# @Last Modified time: 2018-03-28 10:11:45 
#

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
ping -c 1 192.168.2.42 &> /dev/null
if [ "$?" != 0 ] ; then
        echo "Offline"
        exit 1;
fi
#Pruefen, ob autoreboot vorhanden ist
show stats | grep autorebooted:

autoreboot="show stats | grep autorebooted:| tr -s ' '| cut -d : -f 2"

if [ "$?" != 0 ] ; then
        echo $autoreboot
fi

gpus="show stats | grep gpus:| tr -s ' '| cut -d ' ' -f 2 "

echo $gpus

for((i=2;i<=$2+2;i++));
do
    mem$i="show stats | grep mem:| tr -s ' '| cut -d : -f 2 | cut -d ' ' -f $i"

    echo $i
done

