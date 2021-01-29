#!/bin/bash

# exit wenn ein programm nicht mit 0 exited
set -e

cd ~/Sync
echo "Pull von Github"
    git pull --no-rebase origin master

echo "Fertig!"
echo "Kopiere Dateien ins Home Verzeichnis"
    # damit * auch versteckte Dateien findet
    shopt -s dotglob
    cp -R * ~/

    # alle skripte ausführbar machen
    chmod +x ~/.scripts/*

echo "Fertig!"
