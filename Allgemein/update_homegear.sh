#!/bin/bash
###
# Filename:          update_homegear.sh
# Project:           Openhab2-Scripts
# Author:            macbook 
# -----
# File Created:      25-01-2018
# -----
# Last Modified:     25-01-2018
# Modified By:       macbook 
# -----
###


apt-get remove -y homegear libhomegear-base

rm -f homegear*.deb
rm -f libhomegear*.deb
wget http://homegear.eu/downloads/nightlies/libhomegear-base_current_raspbian_stretch_armhf.deb || exit 1
wget http://homegear.eu/downloads/nightlies/homegear_current_raspbian_stretch_armhf.deb || exit 1
wget https://downloads.homegear.eu//nightlies/homegear-homematicwired_current_raspbian_stretch_armhf.deb || exit 1
#wget http://homegear.eu/downloads/nightlies/homegear-homematicwired_current_raspbian_jessie_armhf.deb || exit 1
#wget http://homegear.eu/downloads/nightlies/homegear-insteon_current_raspbian_jessie_armhf.deb || exit 1
#wget http://homegear.eu/downloads/nightlies/homegear-max_current_raspbian_jessie_armhf.deb || exit 1
#wget http://homegear.eu/downloads/nightlies/homegear-philipshue_current_raspbian_jessie_armhf.deb || exit 1
#wget http://homegear.eu/downloads/nightlies/homegear-sonos_current_raspbian_jessie_armhf.deb || exit 1

dpkg -i libhomegear-base_current_raspbian_stretch_armhf.deb
apt-get -y -f install
dpkg -i homegear_current_raspbian_stretch_armhf.deb
apt-get -y -f install
dpkg -i homegear-homematicbidcos_current_raspbian_stretch_armhf.deb
apt-get -y -f install
#dpkg -i homegear-homematicwired_current_raspbian_jessie_armhf.deb
#apt-get -y -f install
#dpkg -i homegear-insteon_current_raspbian_jessie_armhf.deb
#apt-get -y -f install
#dpkg -i homegear-max_current_raspbian_jessie_armhf.deb
#apt-get -y -f install
#dpkg -i homegear-philipshue_current_raspbian_jessie_armhf.deb
#apt-get -y -f install
#dpkg -i homegear-sonos_current_raspbian_jessie_armhf.deb
#apt-get -y -f install