#!/bin/bash
#======================================== ========================================
#
#     FILE:           		led_blinken.sh
#     PROJECT:           		Scripte
#     PATH:			C:\Users\march\Google Drive\Scripte\Eigene\openhab2\led_blinken.sh
#     AUTHOR:              		HelpiStone
#     EMAIL:                  		helpi9007@gmail.com
#     CREATED:          		19-05-2017
#
#     MODIFIED BY:      	Helpi_Stone
#     MODIFIED DATE:  	19-05-2017
#
#     DESCRIPTION:   		""
#
#======================================== ========================================

if [ -z "$1" -o -z "$2" ] ;then
echo "So geht das nicht"
exit 1;
fi
/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "/scripts/led.sh $2"

