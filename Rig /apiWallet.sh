#!/bin/bash

# Kontostand abrufen
data=$(curl 'https://api.etherscan.io/api?module=account&action=balance&address=0x0D177B47dbc3B0747001A47fA0A9F3e9654A4876&tag=latest&apikey=WBWWIHTEDKCDEWXE1M4ZFKYMEJNQVNGH8C')
data=$(echo $data | cut -d '"' -f 12)
# Zahl umwandeln
kontostand=$(awk "BEGIN {print $data / 1000000000000000000}")
# Zahl an Openhab übertragen
url_uptime="http://192.168.2.18:8080/classicui/CMD?ethosWalletKontostand="${kontostand}""
curl -s $url_uptime > /dev/null 2>&1