# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    git_push_config.sh                                 :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: macbook <macbook@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2017/12/31 23:26:32 by macbook           #+#    #+#              #
#    Updated: 2018/01/01 00:08:41 by macbook          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#This is a script to add files to repo, commit, pull and push
DATE=$(date +%d-%m-%Y_%H_%M)
log="/var/log/openhab2/git_push.log"

echo $DATE >> $log

cd /home/helpi/GitBackupDaten/Openhab2-Config
sleep 3
sudo rm -R *
sleep 2
cd ..
sudo cp -arv /etc/openhab2/* Openhab2-Config > /dev/null 2>&1
sleep 2
echo "Ornder Openhab2-Config erneuert" >> $log

cd Openhab2-Config
echo "GitHub Log:" >> $log
echo "" >> $log
git add .  >> $log
git commit -m "$DATE" >> $log
git pull origin master >> $log
git push origin master >> $log
echo "Script ende" >> $log
echo "============\n" >> $log
