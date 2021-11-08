#/bin/bash
# Copies all dotfiles listed in user_dotfiles and system_dotfiles to CONFIG_DIR
# If you pass strings as arguments, only dotfiles that contain at least one of the strings are copied.


# directories where configs will be copied to
CONFIG_DIR=~/Sync/dotfiles
# directories where configs are backuped when updating your configs with the ones from $CONFIG_DIR
BACKUP_DIR=~/Sync/rsync_backup


# rsync with -R will place the files relative to the ., so 
# ~/./.config/conf -> $CONFIG_DIR/home/.config/conf
# append trailing slashes to directories
# could just as well left ~/./ out and make it copy everything to $HOME, but then vim would not suggest the correct filepath :()
declare -a user_dotfiles=(\
    ~/./.zshrc 
    ~/./.bashrc 
    ~/./.aliasrc 
    ~/./.config/ranger/rc.conf
    ~/./.config/ranger/rifle.conf
    ~/./.vimrc 
    ~/./.vim/cocrc.vim
    ~/./.vim/sessions
    ~/./.config/strawberry/strawberry.conf
    # ~/./.config/xfce4/terminal/terminalrc
    ~/./.config/xfce4/
    ~/./.config/bspwm/bspwmrc
    ~/./.config/sxhkd/sxhkdrc
    ~/./.config/polybar/
    ~/./.config/picom.conf
    ~/./.ssh/config
    ~/./.config/rncbc.org/QjackCtl.conf
)
declare -a system_dotfiles=(\
    /etc/./pacman.conf
    /etc/./lxdm/lxdm.conf
    # Where the XDG_..._HOME variables are defined
    /etc/./security/pam_env.conf
    /etc/./xdg/xfce4/
    /etc/./sudoers
    /etc/./X11/xorg.conf.d/00-keyboard.conf
)


# check if a passed parameter is contained in file
check_file_in_args()
{
    if [ $ALL = 1 ]; then
        return 0
    fi
    for string in ${FILES[@]}; do
        if [[ $file == *$string* ]]; then
            return 0
        fi
    done
    return 1
}


# copy configs from arrays in $CONFIG_DIR
save_configs()
{
    # make directories 
    mkdir -p $CONFIG_DIR/home
    mkdir -p $BACKUP_DIR/home
    mkdir -p $CONFIG_DIR/etc
    mkdir -p $BACKUP_DIR/etc

    for file in "${user_dotfiles[@]}"; do
        if check_file_in_args; then
            echo $file
            rsync -aR $file $CONFIG_DIR/home
        fi
    done

    for file in "${system_dotfiles[@]}"; do
        if check_file_in_args; then
            echo $file
            sudo rsync -aR $file $CONFIG_DIR/etc
        fi
    done
}


update_all_configs()
{
    # update user configs
    rsync -aRu --backup-dir $BACKUP_DIR/home $CONFIG_DIR/home $HOME

    # update system configs
    sudo rsync -aRu --backup-dir $BACKUP_DIR/etc $CONFIG_DIR/etc /etc
}


update_configs()
{
    for file in "${user_dotfiles[@]}"; do
        if check_file_in_args; then
            mkdir -p $(dirname $file)
            file=$(echo $file | sed "s|.*/\./||") # remove ~/./ from the filename
            echo $file
            rsync -a --backup-dir $BACKUP_DIR/home $CONFIG_DIR/home/$file $HOME/$file
        fi
    done

    for file in "${system_dotfiles[@]}"; do
        if check_file_in_args; then
            mkdir -p $(dirname $file)
            file=$(echo $file | sed "s|/etc/||") # remove /etc/ from the filename
            echo $file
            sudo rsync -a --backup-dir $BACKUP_DIR/etc $CONFIG_DIR/etc/$file /etc/$file
        fi
    done
}


show_help()
{
    echo "Flags:
Argument        Short   Install:
--help          -h      show this
--backup        -b      copy dotfiles to $CONFIG_DIR
--update        -u      copy dotfiles from $CONFIG_DIR to the correct place
--all           -a      apply operation to all dotfiles

TODO:
--git-pull              pull the files from the git repo
--git-push              push the files in $CONFIG_DIR to the git repo      
--pull          -P      pull the files from my vps
--push          -p      push the files in $CONFIG_DIR to my vps

Any argument without a '-' is interpreted as part of a filepath/name and the selected operation will only be applied to files containing the given string.
"
}


BACKUP=0
UPDATE=0
ALL=0
# all command line args with no "-" are interpreted as part of filepaths. 
FILES=""
while (( "$#" )); do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -b|--backup)
            BACKUP=1
            shift
            ;;
        -u|--update)
            UPDATE=1
            shift
            ;;
        -a|--all)
            ALL=1
            shift
            ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2
            exit 1
            ;;
        *) # everything that does not have a - is interpreted as filepath
            FILES="$FILES $1"
            shift
            ;;
    esac
done


# run the functions
if [ $BACKUP = 1 ]; then
    save_configs
elif [ $UPDATE = 1 ]; then
    if [ $ALL = 1 ]; then
        update_all_configs
    else
        update_configs
    fi
else
    show_help
fi
