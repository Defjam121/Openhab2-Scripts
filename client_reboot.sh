#!/bin/sh
#========================== =======================
#
#     FILE:           		reboot_client.sh
#     PROJECT:          		Scripte
#
#     AUTHOR:           		HelpiStone
#     EMAIL:            		helpi9007@gmail.com
#     CREATED:          	22-04-2017
#
#     MODIFIED BY:      	macbook
#     MODIFIED DATE:  	22-04-2017
#
#     DESCRIPTION:   	"Führt einen Reboot über Openhab aus und sichert die Meldungen in einem Log"
#
#========================== =======================

# Ueberprüfung 

if [ -z "$1" ] ;then
echo "So geht das nicht"
exit 1;
fi
# Datum und Client IP in Log schreiben
echo "########$(date +"%m-%d-%Y")########" >> /var/log/openhab2/restart.log 2>&1
echo "reboot von Client 192.168.2.$1" >> /var/log/openhab2/restart.log 2>&1

# Reboot durchführen und Details in Log Schreiben
/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "shutdown -r now" >> /var/log/openhab2/restart.log 2>&1

echo ""  >> /var/log/openhab2/restart.log 2>&1


