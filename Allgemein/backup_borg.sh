#!/bin/bash

# Skriptvorlage BorgBackup
# https://wiki.ubuntuusers.de/BorgBackup/
# https://borgbackup.readthedocs.io/en/stable/

TODAY=$(date +%Y-%m-%d-%H-%M-%S)
# Hier Pfad zum Sicherungsmedium angeben.
# z.B. zielpfad="/media/peter/HD_Backup"
zielpfad="/media/Nas/openhab2"

# Hier Namen des Repositorys angeben.
# z.B. repository="borgbackups"
repository="borgbackups"

# Hier eine Liste mit den zu sichernden Verzeichnissen angeben
# z.B. sicherung="/home/peter/Bilder /home/peter/Videos --exclude *.tmp"
sicherung="/etc/openhab2 /var/lib/openhab2 /scripts /home/helpi"

# Hier die Art der Verschlüsselung angeben
# z.B. verschluesselung="none"
verschluesselung="repokey"

# Hier die Art der Kompression angeben
# z.B. kompression="none"
kompression="lz4"

# Log Ordner

LOG="/var/log/openhab2/backup_data.log"

# Hier angeben, ob vor der Ausführung von BorgBackup auf vorhandene Root-Rechte geprüft werden soll
# z.B. rootuser="ja"
rootuser="nein"

# Hier angeben nach welchem Schema alte Archive gelöscht werden sollen.
# Die Vorgabe behält alle Sicherungen des aktuellen Tages. Zusätzlich das aktuellste Archiv der 
# letzten 7 Sicherungstage, der letzten 4 Wochen sowie der letzten 12 Monate.
pruning="--keep-within=1d --keep-daily=7 --keep-weekly=4 --keep-monthly=12"

###################################################################################################

repopfad="$zielpfad"/"$repository"

# check for root
if [ $(id -u) -ne 0 ] && [ "$rootuser" == "ja" ]; then
  echo "Sicherung muss als Root-User ausgeführt werden."
  exit 1
fi

# Init borg-repo if absent
if [ ! -d $repopfad ]; then
  borg init --encryption=$verschluesselung $repopfad 
  echo "Borg-Repository erzeugt unter $repopfad"
fi


# backup data
SECONDS=0

# stop openhab instance (here: systemd service)
sudo systemctl stop openhab2.service

echo "##############################################################################" >> $LOG
echo "##############################################################################" >> $LOG
echo $TODAY >> $LOG 
echo "##############################################################################" >> $LOG
echo "Start der Sicherung $(date)." >> $LOG
echo "##############################################################################" >> $LOG
echo "##############################################################################" >> $LOG

BORG_PASSPHRASE="Daniel121" borg create --compression $kompression --exclude-caches --one-file-system -v --stats --progress \
            $repopfad::'openhab2-{now:%Y-%m-%d}' $sicherung >> $LOG 2>&1

echo "Ende der Sicherung $(date). Dauer: $SECONDS Sekunden"  >> $LOG

# prune archives

echo "Anfang Automatisches Löschen von Archiven" >> $LOG


BORG_PASSPHRASE="Daniel121" borg prune -v --list $repopfad --prefix 'openhab2-' $pruning >> $LOG 2>&1

echo "Ende Automatisches Löschen von Archiven" >> $LOG
echo "##############################################################################" >> $LOG
echo "##############################################################################" >> $LOG

# restart openhab instance
sudo systemctl start openhab2.service

echo "" >> $LOG
echo "------------------------------------------------------------------------------" >> $LOG
