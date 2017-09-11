
#!/bin/bash
#======================================== ========================================
#
#     FILE:           		abfrage_log_over_ssh.sh
#     PROJECT:           		Scripte
#     PATH:			C:\Users\march\Google Drive\Scripte\Eigene\openhab2\abfrage_log_over_ssh.sh
#     AUTHOR:              		HelpiStone
#     EMAIL:                  		helpi9007@gmail.com
#     CREATED:          		02-08-2017
#
#     MODIFIED BY:      		Helpi_Stone
#     MODIFIED DATE:  	2017-08-16
#
#     DESCRIPTION:   		"Shellscript zur Abfrage von Sensoren eine Raspberrys über Openhab"
#
#======================================== ========================================
#Pruefen, ob Suffix angegeben
if [ -z "$1" -o -z "$2" ] ;then
    echo "So geht das nicht"
    exit 1;
fi

#Prüfen, ob Host erreichbar
#ping=$(ping -c 1 192.168.2.$1 &> /dev/null)
#if [ "$?" != 0 ] ; then
#        echo "Offline"
#        exit 1;
#fi
#sleep 3
# .log entfernen 
# Prüfen ob $2 oder $3 gegeben ist
if [  -z $3  ]; then
	file=$(echo $2 | cut -d . -f1)
else
	file=$(echo $3 | cut -d . -f1)
	file=$(echo $2_$file)
fi

# Wert des Sensors auslesen

if [  -z $3  ]; then
	((/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "tac /var/log/$2 | head -n 200") > /var/www/html/openhab/$file.txt)
else
	((/usr/bin/ssh -i /scripts/.ssh/id_rsa root@192.168.2.$1 "tac /var/log/$2/$3 | head -n 200") > /var/www/html/openhab/$file.txt)
fi

# echo Name der Datei
#echo "Datei" $file.txt "wurde mit Log-Daten erstellt"

# Ausgabe Datum und Uhrzeit
#date +"%d.%m.%Y %T"

DATUM=$(date +%d.%m.%Y-%T)
echo $DATUM
