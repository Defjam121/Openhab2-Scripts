#This script will automatically backup the necessary openhab2 configuration files to a secondary location on this server and then push to Bitbucket. Do not rely on this local secondary backup location for a backup as it still resides on the local system.

confdir="/etc/openhab2"
userdatadir="/var/lib/openhab2"
runtimedir="/usr/share/openhab2"
logfolder="/data/logs"
logfilename="oh2backup_$(date +%Y%m%d_%H%M%S)"
oh2backupresult=$logfolder/$logfilename
backuploc="/data/openhab2backup"

#Make log folder if it doesn't already exist and create the file that will contain the backup results.
echo "---------------------------Starting--------------------------" >> $oh2backupresult
mkdir -p $logfolder
touch $oh2backupresult

#Sync Directories:
echo "-----------------Syncing openHab2 Directories----------------" >> $oh2backupresult
/usr/bin/rsync -r $confdir $backuploc/configuration
echo "$confdir --> $backuploc/configuration" >> $oh2backupresult
/usr/bin/rsync -r $userdatadir $backuploc/userdata
echo "$userdatadir --> $backuploc/userdata" >> $oh2backupresult
/usr/bin/rsync -r $runtimedir $backuploc/runtime
echo "$runtimedir --> $backuploc/runtime" >> $oh2backupresult

#Add Untracked Files:
echo "--------------------Adding Untracked Files-------------------" >> $oh2backupresult
cd /data/openhab2backup
/usr/bin/git add configuration
/usr/bin/git add userdata
/usr/bin/git add runtime

#Commit:
/usr/bin/git commit -m "generated files on `date +'%Y-%m-%d %H:%M:%S'`" >> $oh2backupresult

#Push:
echo "---------------------Pushing to Bitbucket--------------------" >> $oh2backupresult
/usr/bin/git push >> $oh2backupresult
echo "-----------------------Backup Complete-----------------------" >> $oh2backupresult