#!/bin/bash
DATE=$(date +%d-%m-%Y_%H_%M)

# pfad sollte nicht mit "/" enden!
# Dies ist nur ein Beispiel - bitte an eigene Bedürfnisse anpassen.
# Man muß schreibberechtigt im entsprechenden Verzeichnis sein.
BACKUP_DIR="/media/Nas/Openhab2-conf"

# Hier Verzeichnisse auflisten, die gesichert werden sollen.
# Dies ist nur ein Beispiel - bitte an eigene Bedürfnisse anpassen.
# Bei Verzeichnissen, für die der User keine durchgehenden Leserechte hat (z.B. /etc) sind Fehler vorprogrammiert.
# Pfade sollte nicht mit "/" enden!
SOURCE="/usr/share/openhab"

tar -czPf $BACKUP_DIR/backup_share-$DATE.tar.bz2 $SOURCE

echo "Backup durchgeführt"
