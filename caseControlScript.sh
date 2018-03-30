#!/bin/bash

itunesAPI_URL="10.10.80.214"
itunesAPI_Port="8181"

#Ab hier sind keine Änderungen mehr nötig!
case $1 in
    volume)
        curl -X PUT -d "level=$2" http://$itunesAPI_URL:$itunesAPI_Port/airplay_devices/$3/volume
        ;;
    play)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/play
        ;;
    playpause)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/playpause
        ;;
    pause)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/pause
        ;;
    stop)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/stop
        ;;
    previous)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/previous
        ;;
    next)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/next
        ;;
    mute)
        curl -X PUT -d "muted=$2" http://$itunesAPI_URL:$itunesAPI_Port/mute
        ;;
    shuffle)
        curl -X PUT -d "mode=$2" http://$itunesAPI_URL:$itunesAPI_Port/shuffle
        ;;
    repeat)
        curl -X PUT -d "mode=$2" http://$itunesAPI_URL:$itunesAPI_Port/repeat
        ;;
     *)
          echo "Kommando nicht vorhanden!"
          ;;
esac