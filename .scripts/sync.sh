


target=$(printf "Website\nUni\nDotfiles" | dmenu -p "Was soll synchronisiert werden:")

operation=$(printf "Push\nPull" | dmenu -p "Push oder Pull?")

port_option=""

# bestimme client und server
case $target in
   
    "Website")
        # wähle website aus
        website=$(printf "ge75yag\nquintern\nglowzwiebel\ngabriel" | dmenu -p "Welche Website?")
        client="~/Dokumente/Website/$website"

        # wähle serverpfad
        case $website in
            "Pge75yag")
                server="ge75yag@mytum.de:/WWW/users/ge75yag/"
                port_option="--port 222"
                ;;
            *)
                server="matthias@quintern.xyz:/www/$website"
                ;;
        esac
        ;;


    "Uni")
        client="~/Uni/"
        server="matthias@quintern.xyz:/home/matthias/Uni/" 
        ;;

esac

echo "$target $operation $port_option"

# rsync -a matthias@quintern.xyz:/home/matthias/Uni/Phy_Sem_3/ ~/Dokumente/Uni/Phy_Sem_3













