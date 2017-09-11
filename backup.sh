# stop openhab instance (here: systemd service)
sudo systemctl stop openhab2.service

# prepare backup folder, replace by your desired destination
BACKUPDIR="/media/Nas/Openhab2-conf/openhab2-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUPDIR

# backup current installation with settings
cp -arv /etc/openhab2 "$BACKUPDIR/conf"
cp -arv /var/lib/openhab2 "$BACKUPDIR/userdata"
rm -rf "$BACKUPDIR/userdata/cache"
rm -rf "$BACKUPDIR/userdata/tmp"

# restart openhab instance
sudo systemctl start openhab2.service
