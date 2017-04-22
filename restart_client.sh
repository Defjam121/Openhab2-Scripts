#!/bin/sh

#
#     FILE:           restart.sh
#
#	    AUTHOR:         Helpi
#     EMAIL:          helpi9007@gmail.com
#     CREATED:        09-Feb-2017
#
#     MODIFIED BY:    Helpi
#     MODIFIED DATE:  15-Apr-2017
#
#     DESCRIPTION:    "Führt einen Reboot über Openhab aus und sichert die Meldungen in einem Log"
#
#

echo "$(date +"%m-%d-%Y") : reboot : $1" >> /var/log/openhab2/restart.log 2>&1
SUDO=""
while getopts ":s" opt; do
  case $opt in
    s)
                SUDO="sudo"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
shift $(($OPTIND - 1))
  /usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "shutdown -r now >>" /var/log/openhab2/restart.log 2>&1
