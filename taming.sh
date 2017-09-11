#!/bin/bash

LOG_DIR="/usr/share/openhab2/runtime/karaf/etc/org.ops4j.pax.logging.cfg"

sudo cat extra-logging.cfg >> $LOG_DIR
sudo sed -i -e 's/log4j.logger.smarthome.event = INFO/log4j.logger.smarthome.event = WARN/g' $LOG_DIR
