#!/bin/bash

# This gets all details of the battery to send out in below email
batterystatus=$(/usr/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT1| grep -E 'percentage')

# This gets the integer percentage of current battery capacity
powerstatus=$(/usr/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT1| grep -E 'percentage' | awk '{print $2}' | cut -c -3)

# if batterystatus < 25% send email
if [ "$powerstatus" -lt 25 ]
then
    echo "Battery State is LOW"
    echo "OpenHab battery"$batterystatus | mail -s "OpenHab Status (Low Battery!)" -a "From: "OpenHab" <noreply@cidcomm.com>" alerts@cidcomm.com
    curl --header "Content-Type: text/plain" --request POST --data "$powerstatus" http://10.1.100.23:10005/rest/items/HostBatteryPercentage
else
    echo "Battery State Nominal"
    #echo $batterystatus | mail -s "OpenHab Status (Battery OK!)" -a "From: "OpenHab" <noreply@cidcomm.com>" jay@cidcomm.com
    curl --header "Content-Type: text/plain" --request POST --data "$powerstatus" http://10.1.100.23:10005/rest/items/HostBatteryPercentage
# Debug Output
#echo $batterystatus
#echo $powerstatus
fi