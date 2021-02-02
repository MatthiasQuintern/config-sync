#!/bin/bash
# skript um in ordnern alle inhalte rekursiv mit gpg zu verschlüsseln

shopt -s nullglob
encrypt_folder() {
for file in *
    do
        # prüft ob file ein ordner ist: wenn ja rekursiver aufruf von encrypt_folder
        if [ -d $file ];
        then
            cd $file
            encrypt_folder
            cd ..
        
        # verschlüssle file mit dem key matthiasqui2000@gmail.com
        else
            echo "Verschlüssele $file"
            gpg -e --recipient "matthiasqui2000@gmail.com" $file
            rm $file 
        fi
    done
echo "Dateien wurden nach $crypt_dir verschlüsselt"
}

decrypt_folder() {
for file in *
    do
        # prüft ob file ein ordner ist: wenn ja rekursiver aufruf von decrypt_folder
        if [ -d $file ];
        then
            cd $file
            decrypt_folder
            cd ..
        
        # entschlüssle dateien, output als $dateiname ohne .gpg endung
        else
            echo "Entschlüssele $file"
            gpg -d $file > $(basename $file .gpg) 
            rm $file 
        fi
    done
echo "Dateien wurden nach $crypt_dir entschlüsselt"
}



origin_dir=$PWD

operation=$(printf "Verschlüsseln\nEntschlüsseln" | dmenu -l 2 -p "Operation auf $PWD wählen:")

# kopiert das zielverzeichnis nach ../$zielverzeichnis_en/decrypted und wechselt dort hin, started dann die en/decrypt function
case $operation in
    "Verschlüsseln")
        echo "Beginne Verschlüsseln von $PWD"
        crypt_dir=$PWD"_encrypted"
        cp -dr $origin_dir $crypt_dir
        cd $crypt_dir
        
        encrypt_folder
        ;;
    "Entschlüsseln")
        echo "Beginne Entschlüsseln von $PWD"
        crypt_dir=$PWD"_decrypted"
        cp -dr $origin_dir $crypt_dir
        cd $crypt_dir
        
        decrypt_folder
        ;;
esac
