#!/bin/bash
INPUT=$(/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "/bin/cat /sys/class/thermal/thermal_zone0/temp")
echo $INPUT/1000 |bc -l| python -c "print round(float(raw_input()),2)"
