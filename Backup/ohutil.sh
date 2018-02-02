#!/bin/sh
#======================================== ==================================
#     FILE:             ohutil.sh
#     AUTHOR:           Helpi_Stone
#     EMAIL:            helpi9007@gmail.com
#     CREATED:          2018-01-22
#
#     MODIFIED BY:      Helpi_Stone
#     MODIFIED DATE:    2018-01-22
#
#     DESCRIPTION:      "Beschreibung"
#
#     VERSION:           1.0
#======================================== ==================================

#Usage: ./ohutil.sh <version> (e.g.: ./ohutil.sh 2.2.0)
#In order to run this script you must have installed: wget, unzip, tar

COMMAND=$1
OH_VERSION=$2
DOWNLOAD_URL=https://bintray.com/openhab/mvn/download_file?file_path=org%2Fopenhab%2Fdistro%2Fopenhab%2F$OH_VERSION%2Fopenhab-$OH_VERSION.zip
HOME_PATH=/home/udooer #CHANGE ME!
OH_PATH=$HOME_PATH/openhab #CHANGE ME!
OH_BAKUP_PATH=$HOME_PATH/backup #CHANGE ME!
BACKUP_DATE=$(date +"%Y%m%d%H%M%S")
GLOBAL_EXIT_CODE=1

update_all() {
    echo "Updating all"
    wget $DOWNLOAD_URL -O /tmp/ohnew.zip

    if [ $? -eq 0 ]; then
        echo "Entering backup path: $OH_BAKUP_PATH"
            cd $OH_BAKUP_PATH

        echo "Saving backup openhab2-$BACKUP_DATE.tar.gz"
            tar -zcvf openhab2-$BACKUP_DATE.tar.gz $OH_PATH >/dev/null

        echo "Removing old version"
            rm -rf $OH_PATH/*

            cd /tmp

        echo "Unzipping new version in $OH_PATH"
            unzip ohnew.zip -d $OH_PATH >/dev/null

        GLOBAL_EXIT_CODE=0
    else
        echo "Error downloading openhab version"
    fi
}

backup_conf() {
    echo "Backup config directory"

    echo "Entering backup path: $OH_BAKUP_PATH"

    cd $OH_BAKUP_PATH

    echo "Creating new backup..."

    tar -cjf openhab2-conf-$BACKUP_DATE.tar.gz -C  $OH_PATH conf >/dev/null

    echo "Archive created: openhab2-conf-$BACKUP_DATE.tar.gz"

    GLOBAL_EXIT_CODE=$?
}

backup_userdata() {
    echo "Backup userdata directory"

        echo "Entering backup path: $OH_BAKUP_PATH"

        cd $OH_BAKUP_PATH

        echo "Creating new backup..."

        tar -cjf openhab2-userdata-$BACKUP_DATE.tar.gz -C  $OH_PATH userdata >/dev/null

        echo "Archive created: openhab2-userdata-$BACKUP_DATE.tar.gz"

        GLOBAL_EXIT_CODE=$?

}

case "$COMMAND" in
update-all)
    update_all
  ;;
backup-conf)
    backup_conf
  ;;
backup-userdata)
    backup_userdata
  ;;
*)
  echo "Usage: $0 {update-all|backup-conf|backup-userdata}" >&2
  ;;
esac

exit $GLOBAL_EXIT_CODE
