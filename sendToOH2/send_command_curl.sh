#!/bin/bash
#======================================== ==================================
#     FILE:             send_command_curl.sh
#     AUTHOR:           macbook
#     EMAIL:            helpi9007@gmail.com
#     CREATED:          2017-11-04
#
#     MODIFIED BY:      macbook
#     MODIFIED DATE:    2017-11-04
#
#     DESCRIPTION:      "send coomand over curl zo Openhab2"
#
#     VERSION:           1.0
#======================================== ==================================
# -- Variable ------------
OH_ITEM="$1"
OH_STATE="$2"
OH_HOST="192.168.2.18"
OH_PORT="8080"
OH_BASE_URL="http://${OH_HOST}:${OH_PORT}/rest/items/$OH_ITEM"

# -- Überprüfe ob Werte genannt sind ------------
if [ $# -lt 2 ]; then
    echo "\$1 should be OH ITEM & \$2 should be new state"
    exit 1
fi
# -- Überprüfe ob Item vorhanden ------------
if [ `wget -O - -o /dev/null ${OH_BASE_URL} | grep -c "$OH_ITEM"` -ne 1 ]; then
    echo "Havent found OH item: $OH_ITEM"
    exit 1
fi
# -- Setze state ------------
curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d  "$OH_STATE" "$OH_BASE_URL"
exit 0
