#!/bin/bash
#
# Get usage in percent of the SD card from a Raspberry Pi
# Replace /path/to/key-file
# Replace 111.222.333 with the first three numbers of the IPs of your RPis
# The first argument must be the fourth number of the IP address
#########

disk=$(/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "df -h" | awk '/\/dev\/root/ {print $5}')

disk=$(echo $disk|cut -d % -f1)

echo $disk
