#/bin/bash

SLEEP_TIME=60
BASE_URL="http://192.168.23.11:8080/rest/items"

function check_presence () {
    local MAC=$1
    OH_DEVICE=`echo $MAC |sed -e 's/"//g' |sed -e 's/:/_/g'`
    if [ `sudo l2ping -c1 -t1 $MAC  2>/dev/null; echo $?` -eq 1 ]; then
        STATE="ON"
    else
        STATE="OFF"
    fi
    CMD="curl --max-time 5 --connect-timeout 5 --header 'Content-Type: text/plain' --request PUT --data \"$STATE\" ${BASE_URL}/$OH_DEVICE/state"
    echo -e "CMD:\n$CMD"
    eval ${CMD}
}

if [ $# -eq 0 ]; then
    while true
    do
        # Amelungs TV
        check_presence "BC:30:7D:40:74:E6"
        # Sepps Galaxy
        #check_presence "10:30:47:E1:C6:FC"
        sleep $SLEEP_TIME
    done
else
        check_presence "$1"
fi
