#!/bin/bash
/usr/bin/ssh -i /scripts/.ssh/id_rsa pi@192.168.2.135 "/scripts/tts.sh \"$1\" $2 $3" &> /dev/null

