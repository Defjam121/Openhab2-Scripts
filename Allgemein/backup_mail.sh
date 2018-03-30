#!/bin/bash
# Script fuer inkrementelles Backup mit 30 taegigem Vollbackup

### Einstellungen ##
BACKUPDIR="media/backup"           ## Pfad zum Backupverzeichnis
ROTATEDIR="media/backup/rotate"    ## Pfad wo die Backups nach 30 Tagen konserviert werden
TIMESTAMP="timestamp.dat"          ## Zeitstempel
SOURCE="home/helpi"                 ## Verzeichnis(se) welche(s) gesichert werden soll(en)
DATUM="$(date +%d-%m-%Y)"          ## Datumsformat einstellen
ZEIT="$(date +%H:%M)"              ## Zeitformat einstellen >>Edit bei NTFS und Verwendung auch unter Windows : durch . ersetzen

### Verzeichnisse/Dateien welche nicht gesichert werden sollen ! Achtung keinen Zeilenumbruch ! ##
EXCLUDE="--exclude=home/user/Filme --exclude=home/user/Musik --exclude=home/user/Spiele --exclude=home/user/.VirtualBox  --exclude=home/user/.local/share/Trash"

### Wechsel in marchelpenstein@gmail.com.com damit die Pfade stimmen ##
cd /

### Backupverzeichnis anlegen ##
mkdir -p ${BACKUPDIR}

### Test ob Backupverzeichnis existiert und Mail an Admin bei fehlschlagen ##
if [ ! -d "${BACKUPDIR}" ]; then

mail -s "Backupverzeichnis nicht vorhanden!" marchelpenstein@gmail.com <<EOM
Hallo Admin,
das Backup am ${DATUM} konnte nicht erstellt werden. Das Verzeichnis ${BACKUPDIR} wurde nicht gefunden und konnte auch nicht angelegt werden.
Mit freundlichem Gruss
Ihr Server
EOM

 . exit 1
fi

### Alle Variablen einlesen und letzte Backupdateinummer herausfinden ##
set -- ${BACKUPDIR}/backup-???.tgz
lastname=${!#}
backupnr=${lastname##*backup-}
backupnr=${backupnr%%.*}
backupnr=${backupnr//\?/0}
backupnr=$[10#${backupnr}]

### Backupdateinummer automatisch um +1 bis maximal 30 erhoehen ##
if [ "$[backupnr++]" -ge 30 ]; then
mkdir -p ${ROTATEDIR}/${DATUM}-${ZEIT}

### Test ob Rotateverzeichnis existiert und Mail an Admin bei fehlschlagen ##
if [ ! -d "${ROTATEDIR}/${DATUM}-${ZEIT}" ]; then

mail -s "Rotateverzeichnis nicht vorhanden!" marchelpenstein@gmail.com <<EOM
Hallo Admin,
die alten Backups konnten am ${DATUM} nicht verschoben werden. Das Verzeichnis ${ROTATEDIR} wurde nicht gefunden und konnte auch nicht angelegt werden.
Mit freundlichem Gruss
Ihr Server
EOM

 . exit 1
else
### alter Code: mv ${BACKUPDIR}/* ${ROTATEDIR}/${DATUM}-${ZEIT}  Damit verschiebt er die Dateien in sich selbst weil rotate ein Unterverzeichnis von backup ist. Es kommt zur Fehlermeldung ##
### /b* und /t* weil die Dateien nur mit b und t beginnen ##
mv ${BACKUPDIR}/b* ${ROTATEDIR}/${DATUM}-${ZEIT}
mv ${BACKUPDIR}/t* ${ROTATEDIR}/${DATUM}-${ZEIT}
fi

### Abfragen ob das Backupverschieben erfolgreich war ##
if [ $? -ne 0 ]; then

mail -s "Backupverschieben fehlerhaft!" marchelpenstein@gmail.com <<EOM
Hallo Admin,
die alten Backups konnte am ${DATUM} nicht verschoben werden.
Mit freundlichem Gruss
Ihr Server
EOM

exit 1
else

mail -s "Backupverschieben erfolgreich" marchelpenstein@gmail.com <<EOM
Hallo Admin,
die alten Backups wurde am ${DATUM} erfolgreich nach ${ROTATEDIR}/${DATUM}-${ZEIT} verschoben.
Mit freundlichem Gruss
Ihr Server
EOM

### die Backupnummer wieder auf 1 stellen ##
backupnr=1
fi
fi

backupnr=000${backupnr}
backupnr=${backupnr: -3}
filename=backup-${backupnr}.tgz

### Nun wird das eigentliche Backup ausgefuehrt ##
tar -cpzf ${BACKUPDIR}/${filename} -g ${BACKUPDIR}/${TIMESTAMP} ${SOURCE} ${EXCLUDE}

### Abfragen ob das Backup erfolgreich war ##
if [ $? -ne 0 ]; then

mail -s "Backup (${SOURCE}) war fehlerhaft!" marchelpenstein@gmail.com<<EOM
Hallo Admin,
das Backup ${filename} am ${DATUM} wurde mit Fehler(n) beendet.
Mit freundlichem Gruss
Ihr Server
EOM

else

mail -s "Backup (${SOURCE}) war erfolgreich" marchelpenstein@gmail.com <<EOM
Hallo Admin,
das Backup ${filename} am ${DATUM} wurde erfolgreich beendet.
Mit freundlichem Gruss
Ihr Server
EOM

fi

