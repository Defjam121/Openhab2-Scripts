#!/bin/bash -e

# First do apt-get update
/usr/bin/sudo apt-get update

# Then the upgrade
/usr/bin/sudo apt-get -y upgrade
/usr/bin/sudo apt-get -y dist-upgrade
# Finally rpi-update
/usr/bin/sudo apt-get -y  autoremove
