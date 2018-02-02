#!/bin/bash

# moverules.sh rules rulesx 

ORG=$1
NEW=$2
IGNORE=moverules.rules

for f in /etc/openhab2/rules/*.${ORG};
do
    CURRENT=$(basename $f)
    if [ "$CURRENT" == "$IGNORE" ]    
    then
    	echo "ignoring $IGNORE"
    else
        OLDFILE=$f
        NEWFILE=${f%$ORG}$NEW
        mv "$OLDFILE" "$NEWFILE"
    fi
done