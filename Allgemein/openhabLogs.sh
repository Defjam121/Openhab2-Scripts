#!/bin/bash
tac /var/log/openhab2/events.log | head -n 200 > /var/www/html/openhab/events.txt
tac /var/log/openhab2/openhab.log | head -n 200 > /var/www/html/openhab/openhab.txt
date +"%d.%m.%Y %T"
