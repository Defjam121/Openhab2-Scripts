#!/bin/bash

#Current date
datum=$(date +%s)

#1st argument defines kind of trash
trash_kind=$1

#use respective trash text file
trash_file="/opt/openhab/openhab2/conf/shellscripts/trash_$trash_kind.txt"

#loop searching the text file to find the first date > today
#time read from text file is always 00:00:00h -> #86399sec = 23:59:59h to include current day
while read datum_line
do
	datum_line_sec=$(date -d $datum_line +%s)
	let datum_diff=$datum-$datum_line_sec
	if [ $datum_diff -lt 86399 ]
	then
		echo $datum_line
		exit 0
	fi
done < $trash_file

echo "Error"
exit 1;