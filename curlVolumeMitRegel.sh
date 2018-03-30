#!/bin/bash
curl -X PUT -d "level=$1" http://XXX.XXX.XXX.XXX:8181/airplay_devices/$2/volume

# rule"MAIN Volume"
# when
#   //DIMMER ITEM
#   Item Volume_Main received update
# then
#   executeCommandLine("/etc/openhab2/scripts/iTunes_Volume.sh " + Volume_Main.state + " Computer")
# end
# 
# rule"Volume Büro"
# when
# //DIMMER ITEM
#   Item Volume_Buero received update
# then
#   executeCommandLine("/etc/openhab2/scripts/iTunes_Volume.sh " + Volume_Buero.state + " ID_FROM_AIRPLAY_DEVICE")
# end