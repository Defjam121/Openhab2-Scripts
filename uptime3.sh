#!/bin/bash
#
#   upt - show just the system uptime, days, hours, and minutes

upSeconds="$(cat /proc/uptime) && echo ${temp%%.*})"
secs=$((${upSeconds}%60))
mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24))
days=$((${upSeconds}/86400))
if [ "${days}" -ne "0" ]
then
   echo -n "${days}d"
fi
echo -n "${hours}h${mins}m"
