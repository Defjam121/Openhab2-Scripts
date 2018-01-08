#!/bin/bash
#
# Script by Jamie R. Cid
# jay@cidcomm.com
#
#Get data from MyTotalControl and send to OH. This grabs one copy of the data and stores it instead of doing it for every request below. That's how you get blocked ;)
echo Getting Data from MyTotalControl Website
/etc/thermostat.py -s > /var/log/honeywell.log
TEMPDATA="/var/log/honeywell.log"
#
#
echo Checking Indoor Temp
TEMPSTATUS=$( grep "Indoor Temperature" $TEMPDATA | sed -n -e 's/^.*Indoor Temperature: //p')
curl --header "Content-Type: text/plain" --request POST --data "$TEMPSTATUS" http://10.1.100.23:10005/rest/items/IndTemp
echo $TEMPSTATUS
#
echo Checking Heat Setpoint
HEATSTATUS=$( grep "Heat Setpoint" $TEMPDATA | sed -n -e 's/^.*Heat Setpoint: //p')
curl --header "Content-Type: text/plain" --request POST --data "$HEATSTATUS" http://10.1.100.23:10005/rest/items/IndHeat
curl --header "Content-Type: text/plain" --request POST --data "$HEATSTATUS" http://10.1.100.23:10005/rest/items/IndHeatSet
echo $HEATSTATUS
#
echo Checking Heat On/Off Status
HEATERSTATUS=$( grep "Status Heat" $TEMPDATA | sed -n -e 's/^.*Status Heat: //p')
curl --header "Content-Type: text/plain" --request POST --data "$HEATERSTATUS" http://10.1.100.23:10005/rest/items/IndHeaterStatus
echo $HEATERSTATUS