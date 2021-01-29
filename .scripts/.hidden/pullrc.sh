#!/bin/bash

# exit wenn ein programm nicht mit 0 exited
set -e

cd ~/Sync
echo "Pull von Github"
    git pull --no-rebase origin master

echo "Fertig!"
echo "Kopiere Dateien ins Home Verzeichnis"
    # dotglob damit * auch versteckte Dateien findet
    # extglob damit alles gefunden wird ausser .git
    shopt -s dotglob extglob
    cp -R !(*git) ~/

    # alle skripte ausführbar machen
    chmod +x ~/.scripts/*

echo "Fertig!"
