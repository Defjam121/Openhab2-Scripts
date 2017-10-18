#!/bin/bash
#======================================== ==================================
#     FILE:             syno_status_vm.sh
#     AUTHOR:           macbook
#     EMAIL:            helpi9007@gmail.com
#     CREATED:          2017-10-14
#
#     MODIFIED BY:      macbook
#     MODIFIED DATE:    2017-10-14
#
#     DESCRIPTION:      "Beschreibung"
#
#     VERSION:           1.0
#######################################
##    Speicherplatz         ##
#######################################
# HDD verwendet in %
HDD1=$(df -h | tr -s ' ' $'\t' | grep /dev/sda1 | cut -f5 | sed 's/%/ /g' )
# HDD verfügbar in MB
HDD2=$(df -h | tr -s ' ' $'\t' | grep /dev/sda1 | cut -f4 | sed 's/M/ /g')
# HDD benutzt in MB
HDD3=$(df -h | tr -s ' ' $'\t' | grep /dev/sda1 | cut -f4 | sed 's/M/ /g')

#######################################
##    Laufzeit         ##
#######################################
# Ausgabe in Tage Stunden Minuten
uptime=$(uptime -p)
uptime=$(echo $uptime | sed 's/up //g' | sed 's/, / /g' | sed 's/ /%20/g' | sed 's/days/Tage/g' | sed 's/day/Tag/g' | sed 's/hours/Stunden/g' | sed 's/hour/Stunde/g' | sed 's/minutes/Minuten/g' | sed 's/minute/Minute/g' )
# Ausgabe hh:mm
uptime=$(uptime | awk '{printf($3$4)}' | cut -d , -f1)
