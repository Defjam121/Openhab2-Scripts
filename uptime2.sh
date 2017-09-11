#!/bin/bash
#
# Get the uptime of localhost or a remote server
# Replace XX with the fourth number of the IP address of localhost, so you don't use SSH then
# Replace 111.222.333 with the first three numbers of the IPs of your server
# The first argument must be the fourth number of the IP address
#########

#up=$(/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "uptime -p")
up=$(uptime -p)


#echo $up | sed 's/up //g'
# Uncomment line after and comment line before to translate to German
#up=$(sed 's/up //g' | sed 's/days/Tage/g' | sed 's/day/Tag/g' | sed 's/hours/Stunden/g' | sed 's/hour/Stunde/g' | sed 's/minutes/Minuten/g' | sed 's/minute/Minut$')
echo $up
