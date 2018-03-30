#!/bin/bash
# Homematic CCU Backup Script fuer crontab
# 13.03.11 - Danny B.
#

# Parameter
backupdir="/mnt/Nas/CCU_Backup/Day"
host="192.168.2.19"
keepdays="200"
user="backup"
password="Daniel121"
run=$0.lastrun

# Homematic Login
wget --post-data '{"method":"Session.login","params":{"username":"'$user'","password":"'$password'"}}' http://$host/api/homematic.cgi -O hm.login.response -q >$run 2>&1

# Login-Pruefung
loginerror=`cat hm.login.response|cut -d "," -f3|awk '{print $2}'`
if [ "$loginerror" != "null}" ]; then
  echo "Fehler beim Homematic-Login !"|tee -a $run
  cat hm.login.response|grep message|cut -d '"' -f4|tee -a $run
  exit 1
fi
sessionid=`cat hm.login.response|cut -d "," -f2|awk '{print $2}'|cut -d '"' -f2`

# Backupdatei herunterladen
wget "http://$host/config/cp_security.cgi?sid=@$sessionid@&action=create_backup" -O $backupdir/$host-backup_$(date +%Y-%m-%d_%H-%M).tar.sbk -q >>$run 2>&1

# Homematic Logout
wget --post-data '{"method":"Session.logout","params":{"_session_id_":"'$sessionid'"}}' http://$host/api/homematic.cgi -O hm.logout.response -q >>$run 2>&1

# temp. Dateien loeschen
rm hm.login.response hm.logout.response >>$run 2>&1

# alte Backups loeschen
find $backupdir -name $host-backup_*.sbk -mtime +$keepdays -exec rm '{}' \; >>$run 2>&1
