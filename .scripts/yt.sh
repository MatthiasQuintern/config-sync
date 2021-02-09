#!bin/sh
# Matthias Quintern
# 2021

read -p "Url eingeben: " url

youtube-dl -F $url && 
read -p "Typ wählen: " typ
read -p "Konertieren nach: (n/mp3): " format
read -p "Dateiname eingeben: " name

case $format in
    mp3)
        youtube-dl -f $typ $url -o - | ffmpeg -i  pipe:0 -acodec libmp3lame $name
        ;;

    *)
        youtube-dl -f $typ $url -o $name
        ;;
esac

