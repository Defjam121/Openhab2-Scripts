#!/bin/bash
OH_ITEM="$1"
OH_STATE="$2"
if [ $# -lt 2 ]; then
    echo "\$1 should be OH ITEM & \$2 should be new state"
    exit 1
fi
OH_HOST="192.168.2.18"
OH_PORT="8080"
OH_BASE_URL="http://${OH_HOST}:${OH_PORT}/classicui/CMD?$OH_ITEM"
#if [ `curl ${OH_BASE_URL} > /dev/null 2>&1 | grep -c "<name>$OH_ITEM</name>"` -ne 1 ]; then
#if [ `wget -O - -o /dev/null ${OH_BASE_URL} | grep -c "<name>$OH_ITEM</name>"` -ne 1 ]; then
 #   echo "Havent found OH item: $OH_ITEM"
 #   exit 1
#fi

#curl --header "Content-Type: text/plain" --request PUT --data "$OH_STATE" "$OH_BASE_URL/state"
curl $OH_BASE_URL=$OH_STATE
exit 0
