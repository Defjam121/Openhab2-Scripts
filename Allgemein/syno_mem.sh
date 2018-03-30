#!/bin/sh

mem=$(/usr/bin/ssh -i /scripts/.ssh/id_rsa marc@192.168.2.142 "df|awk '/volume1$/'")
#mem=$(/usr/bin/ssh marc:Daniel121@192.168.2.142"df|awk '/v

#{printf($3/$2*100)}
#printf $mem
mem=$(echo $mem($3/$2*100))
printf $mem ($3/$2*100)
