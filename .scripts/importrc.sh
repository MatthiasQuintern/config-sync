#!/bin/bash

echo "Kopiere Dateien nach ~/Sync"
    # kopiere rc dateien ~/Sync
    cp -f ~/.bashrc ~/Sync/.bashrc
    cp -f ~/.zshrc ~/Sync/.zshrc
    cp -f ~/.aliasrc ~/Sync/.aliasrc
    cp -f ~/.vimrc ~/Sync/.vimrc
    
    # kopiere .scripts Ordner
    cp -fr ~/.scripts ~/Sync/.scripts


echo "Fertig!"

echo "Git Commit der Dateien"
    cd ~/Sync
    git add *
    git commit -m "Update über importrc.sh"

echo "Fertig!"

echo "Pushe Dateien auf Github"
    git push -u origin master
echo "Fertig!"


