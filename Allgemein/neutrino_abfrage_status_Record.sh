#!/bin/sh
### Scriptname:            neutrino_abfrage_status:Record.sh
### Kurzbeschreibung:      Es wird der aktuelle record mode Status zurückgegeben
### Ersteller:             Marc Helpenstein
### Datum:				   02-03-17
###
#########################################################

# Abfrage Record Mode

status=$(curl "http://192.168.2.104/control/setmode?status")

echo $status
