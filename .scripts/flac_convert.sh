#!/bin/bash
# Made by Matthias Quintern
# 22.12.2020
# Argument: ursprungs-dateiendung
endung="$1"
cd "$PWD"
for file in *".$endung"
do
	ffmpeg -i "$file" -acodec flac "$(basename "${file/.$endung}")".flac
	echo "Wurde konvertiert zu flac: $file"
done
read -p "Sollen die alten Dateien gelöscht ('d') oder in einen neuen Ordner verschoben ('m') werden? [d/m/n]:" answer
case $answer in 
	# Löschen der alten Dateien
	[dD]*) 
	for file in *".$endung"
	do
		rm "$file"
		echo "Wurde gelöscht: $file"
	done
	echo "Alte Dateien wurden gelöscht. Fertig!"
	;;
	# Verschieben der alten Dateien in /old_files
	[mM]*)
	mkdir old_files
	for file in *".$endung"
	do
		mv "$file" old_files
		echo "Wurde nach 'old_files' verschoben: $file"
	done
	echo "Alte Dateien wurden verschoben. Fertig!"
	;;
	# Nichts tun
	* ) echo "Keine Dateien gelöscht. Fertig!"
	;;
esac

