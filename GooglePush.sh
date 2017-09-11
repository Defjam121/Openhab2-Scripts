#!/bin/bash
## Ein bewusst einfach gehaltenes Shell-Script zum Hochladen
 
DRIVE="/opt/go/bin/drive push -no-prompt"
 
cd /home/helpi/gdrive
$DRIVE openhab2-Config

