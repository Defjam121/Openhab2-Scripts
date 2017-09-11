#!/bin/bash
if [ -z "$1" -o -z "$2" -o -z "$3" ] ;then
echo "So geht das nicht"
exit 1;
fi

/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "/usr/local/bin/gpio write $2 $3"
