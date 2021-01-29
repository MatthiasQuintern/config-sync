


target=$(printf "Website\nUni\nDotfiles" | dmenu -p "Was soll synchronisiert werden:")

operation=$(printf "Push\nPull" | dmenu -p "Push oder Pull?")

port="22"

# bestimme client und server
case $target in
   
    "Website")
        # wähle website aus
        website=$(printf "ge75yag\nquintern\nglowzwiebel\ngabriel" | dmenu -p "Welche Website?")
        client="$HOME/Dokumente/Website/$website"

        # wähle serverpfad
        case $website in
            "ge75yag")
                server="ge75yag@cipgate.ph.tum.de:/WWW/users/ge75yag/"
                port="222"
                ;;
            *)
                server="matthias@quintern.xyz:/www/$website"
                ;;
        esac
        ;;


    "Uni")
        client="$HOME/Uni/"
        server="matthias@quintern.xyz:/home/matthias/Uni/" 
        ;;

    "Dotfiles")
        # führt das pushrc oder pullrc skript aus
        case $operation in
            "Push")
                sh "$HOME/.scripts/.hidden/pushrc.sh"
                ;;
            "Pull")
                sh "$HOME/.scripts/.hidden/pullrc.sh"
                ;;
        esac
        # beendet das skript da git benutzt wird und nicht rsync
        exit 0
esac

# führt die kommandos aus, je nachdem ob gepushed oder gepulled wird
case $operation in
    "Push")
        rsync -av -e "ssh -p $port" $client $server
        ;;
    "Pull")
        rsync -av -e "ssh -p $port" $server $client
        ;;
esac
















