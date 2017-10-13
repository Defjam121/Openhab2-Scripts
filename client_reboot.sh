#!/bin/bash
#======================================== ==================================
#     FILE:                                client_reboot.sh
#     AUTHOR:                        macbook
#     EMAIL:                             helpi9007@gmail.com
#     CREATED:                      2017-09-12
#
#     MODIFIED BY:                Defjam
#     MODIFIED DATE:           2017-10-13
#
#     DESCRIPTION:               "Client herunterfahren oder restarten. Log mit Datum und IP erstellen"
#
#     VERSION:                        1.0
#======================================== ==================================
##########################################
## Ueberprüfung ob $1 und $2 gegeben sind
##########################################

if [ -z "$1" -o -z "$2" ] ;then
echo "So geht das nicht"
exit 1;
fi

############################################
##    Datum und Client IP in Log schreiben
############################################

cat <<-EOF  >> /var/log/openhab2/restart.log 2>&1

#######################################
##    Datum : $(date +"%m-%d-%Y")
##    Client 192.168.2.$1
#######################################

EOF

#######################################
##    Prüfen, ob Host erreichbar
#######################################

ping -c 1 192.168.2.$1 &> /dev/null
if [ "$?" != 0 ] ; then
        echo "Offline" >> /var/log/openhab2/restart.log 2>&1
        exit 1;
fi

# Reboot durchführen und Details in Log Schreiben
echo "Reboot wird gestartet" >> /var/log/openhab2/restart.log 2>&1
sleep 5
echo "" >> /var/log/openhab2/restart.log 2>&1
if [[ "$1" = 8 ]]; then
    /usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "/sbin/_shutdown $2 now" >> /var/log/openhab2/restart.log 2>&1
else
    /usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "shutdown $2 now" >> /var/log/openhab2/restart.log 2>&1
fi
echo "" >> /var/log/openhab2/restart.log 2>&1
echo ""  >> /var/log/openhab2/restart.log 2>&1

echo "#######################################"  >> /var/log/openhab2/restart.log 2>&1
