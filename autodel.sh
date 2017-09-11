#!/bin/bash

#INPUT=$(/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "gpio read $2")
find "/media/Nas/Openhab" -mtime +14 -type f -exec rm -rf {} \;
touch "/media/Nas/Openhab/touch1"
find "/media/Nas/Openhab" -type d -empty -exec rmdir {} \;
