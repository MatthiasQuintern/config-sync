#!/bin/sh
#
# Menü für alle meine Skripte im .scripts Ordner

choice=$(ls -A ~/.scripts | dmenu -p "Skript auswählen:")

# -z wenn der string leer ist
if [ -z $choice ]; then
    echo "script-menu: nothing selected"
    
else
 
    echo "script-menu: run $choice" 
    exec ~/.scripts/$choice

fi

