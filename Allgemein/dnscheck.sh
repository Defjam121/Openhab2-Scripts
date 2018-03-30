#!/bin/bash

#Pruefen, ob Suffix angegeben
if [ -z "$1" ] ;then
    echo "So geht das nicht"
    exit 1;
fi

/usr/bin/dig @$1 $2 > /dev/null
DNSTEST=$?

if [ $DNSTEST -eq 0 ]; then
    echo "ON"
else
    echo "OFF"
fi
