#!/bin/bash
# Get the dir to cd back to it when leaving
CONFIG_DIR=$PWD
# Path to the config sync script
CONFIG_SYNC="$HOME/.scripts/config_sync.sh --update"
# CONFIG_DIR=~/Sync/dotfiles
WINE_DIR=$HOME/.wine


INIT=0

# indent shows tree
CORE=0
    TERMINAL_PROGRAMS=0
        ZSH=0
        VIM=0
    X=0
    BSPWM=0
    XFCE=0
    GRAPHICAL_PROGRAMS=0
TUM_VPN=0
WINE=0
JACK=0

show_help()
{
    echo "Flags:
    Argument        Short   Install:
    --init          -i      pacman.conf, sudo, pam_env
    --core          -c      --terminal --X --BSPWM --XFCE --graphical
    --zsh                   zsh shell
    --X --x         -x      Xorg, LXDM
    --bspwm         -b      BSPWM with polybar, sxhkd, pywal, nitrogen, picom
    --xfce                  xfce4 desktop environment, thunar & some other xfce4 programs      
    --terminal      -t      command line programs, including --zsh --vim 
    --graphical     -g      gui programs
    --eduvpn                eduvpn
    --wine          -w      wine, wineasio, winetricks, create default wineprefix
    --jack          -j      jack2, qjackctl
    "
}

while (( "$#" )); do
    case "$1" in
        -i|--init)
            INIT=1
            shift
            ;;
        -c|--core)
            CORE=1
            shift
            ;;
        --zsh)
            ZSH=1
            shift
            ;;
        --X|--x)
            X=1
            shift
            ;;
        --bspwm)
            BSPWM=1
            shift
            ;;
        --xfce)
            XFCE=1
            shift
            ;;
        -t|--terminal)
            TERMINAL_PROGRAMS=1
            shift
            ;;
        -g|--graphical)
            GRAPHICAL_PROGRAMS=1
            shift
            ;;
        --eduvpn)
            TUM_VPN=1
            shift
            ;;
        --wine)
            WINE=1
            shift
            ;;
        --jack)
            JACK=1
            shift
            ;;
        *) # unsupported flags
            echo "Error: Unsupported argument or flag $1" >&2
            show_help
            exit 1
            ;;
    esac
done




# INIT: pacman conf, sudo and pam_env (for XDG_..._HOME variables)
if [ $INIT = 1 ]; then
    if [ ! $(whoami) -e "root" ]; then
        echo "Initialisation needs to be run as root."
        exit 1
    fi

    echo "Installing pacman.conf"
    cp etc/pacman.conf /etc/

    echo "Installing pam_env"
    cp etc/security/pam_env.conf /etc/security/

    echo "Updating pacman mirrors"
    pacman -Sy

    echo "Installing sudo with sudoers config"
    pacman -S sudo
    cp etc/sudoers /etc

    echo "Please log out and log in as user, then run \"echo \$XGD_CONFIG_HOME\". It should not be empty"
    exit 0
fi


# allow script to only be run as user
# the scripts uses "~" and I dont want the stuff to end up in /root
# also, you shouldnt run yay as root
if [ $(whoami) = "root" ]; then
    echo "This script uses sudo if it needs root-rights. Please run it as user."
    exit 1
fi


echo "Updating pacman mirrors"
sudo pacman -Sy

# INSTALL TERMINAL PROGRAMS
if [ $TERMINAL_PROGRAMS = 1 ] || [ $CORE = 1 ]; then
    echo "Installing terminal programs:\n wget, git, ffmpeg, rsync, zip, unzip, tar, ntfs, neofetch, gnu-debugger(gdb), youtube-dl fakeroot"
    sudo pacman -S wget git ffmpeg rsync zip unzip tar ntfs-3g neofetch gdb youtube-dl python-pip fakeroot make patch

    echo "Installing yay - AUR helper"
    cd /tmp
    git clone https://aur.archlinux.org/yay-git.git
    cd yay-git
    makepkg -si
    cd $CONFIG_DIR

    # RANGER
    echo "Installing ranger"
    sudo pacman -S ranger
    echo "Installing ranger config files"
    $CONFIG_SYNC ranger

    # NICOLE
    echo "Installing nicole"
    cd /tmp
    git clone "https://github.com/MatthiasQuintern/nicole"
    cd nicole
    sudo pip3 install .

    cd $CONFIG_DIR
fi


# INSTALL ZSH
if [ $ZSH = 1 ] || [ $TERMINAL_PROGRAMS = 1 ] || [ $CORE = 1 ]; then
    echo "Installing zsh, zsh-syntax-highlighting"
    sudo pacman -S zsh zsh-syntax-highlighting
    echo "Setting zsh as default shell"
    sudo usermod -s /bin/zsh $(whoami)
    echo "Installing zshrc"
    $CONFIG_SYNC zsh
fi 


# INSTALL VIM
if [ $VIM = 1 ] || [ $TERMINAL_PROGRAMS = 1 ] || [ $CORE = 1 ]; then
    echo "Installing vim (gvim), clang, doxygen and texlive"
    sudo pacman -S gvim nodejs npm clang doxygen texlive-core texlive-latexextra
    # vimrc
    $CONFIG_SYNC vim
    # plugged
    echo "Installing vim-plug plugin manager"
    mkdir -p ~/.vim/autoload/master
    # wget "https://github.com/junegunn/vim-plug/plug.vim" -o "~/.vim/autoload/master/plug.vim"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo "Installing vim plugins listed in vimrc"
    vim -c PlugInstall
    echo "Installing coc-extensions: clangd, python"
    vim -c "CocInstall coc-clangd" -c "CocInstall coc-python"
fi


# INSTALL X and LXDM
if [ $X = 1 ] || [ $CORE = 1 ]; then
    echo "Instaling X-window system"
    sudo pacman -S xorg-server xorg-apps
    # https://wiki.archlinux.org/title/Xorg

    # install drivers
    driver=0
    read -p "Please select a driver:\n1) nvidia\n2) nouveau\n3) intel\n4) amd\nDriver (number): " driver
    case $driver in
        1)
            drivers="nvidia nvidia-utils lib32-nvidia-utils" ;;
        2)
            drivers="mesa lib32-mesa xf86-video-nouveau" ;;
        3)
            drivers="mesa lib32-mesa xf86-video-intel vulkan-intel" ;;
        4)
            drivers="mesa lib32-mesa xf86-video-amdgpu vulkan-radeon" ;;
        *)
            drivers="" ;;
    esac
    sudo pacman -S $drivers

    echo "Instaling lxdm"
    sudo pacman -S lxdm
    echo "Installing lxdm arch themes"
    yay -S lxdm-themes
    echo "Installing config file"
    $CONFIG_SYNC lxdm
    echo "Enabling lxdm"
    sudo systemctl enable lxdm
fi


# INSTALL BSPWM
if [ $BSPWM = 1 ] || [ $CORE = 1 ]; then
    echo "Installing BSPWM with SXHKD, picom, polybar (->needs pywal rofi playerctl, python-dbus, ttf-nerd-fonts-symbols, ttf-unifont) and nitrogen"
    sudo pacman -S bspwm sxhkd picom python-pywal rofi playerctl python-dbus ttf-unifont ttf-nerd-fonts-symbols nitrogen 
    yay -S ttf-unifont
    yay -S polybar
    echo "Install rc-files"
    $CONFIG_SYNC bspwm sxhkdrc picom polybar
    echo "Launch nitrogen when X is set up to select a wallpaper"
    echo "Run ~/.config/polybar/shapes/scripts/pywal.sh to generate a polybar color theme for the wallpaper"
fi


# INSTALL XFCE4
if [ $XFCE = 1 ] || [ $CORE = 1 ]; then
    echo "Installing xfce4 with some extras:"
    sudo pacman -S xfce4 thunar-media-tags-plugin xfce4-mount-plugin xfce4-notifyd xfce4-pulseaudio-plugin xfce4-screensaver xfce4-taskmanager xfce4-whiskermenu-plugin
    echo "Installing xfce4 configs"
    $CONFIG_SYNC xfce4
fi


# INSTALL GRAPHICAL_PROGRAMS
if [ $GRAPHICAL_PROGRAMS = 1 ] || [ $CORE = 1 ]; then
    echo "Installing graphical programs - core:\nxfce4-terminal, ueberzug flameshot, firefox, libreoffice zathura + pdf, sxiv, pavucontrol catfish"
    sudo pacman -S xfce4-terminal uerbezug flameshot firefox libreoffice-fresh libreoffice-fresh-de zathura zathura-pdf-poppler sxiv pavucontrol catfish
    echo "Installing xfce4 terminal rc"
    $CONFIG_SYNC terminal

    echo "Installing graphical programs - media:\ngimp, strawberry, vlc, audacity"
    sudo pacman -S gimp strawberry vlc audacity
    echo "Installing configs"
    $CONFIG_SYNC strawberry gimp audacity
    echo "Installing graphical programs - other:\nsteam, discord, ubuntu fonts"
    sudo pacman -S steam discord ttf-ubuntu-font-family
fi


# INSTALL TUM eduvpn
if [ $TUM_VPN = 1 ]; then
    echo "Installing and enabling networkmanager, openvpn, networkmanager-openvpn"
    sudo pacman -S networkmanager openvpn networkmanager-openvpn
    sudo systemctl enable --now NetworkManager
    echo "Installing eduvpn-cli"
    sudo pip3 install "eduvpn-client"
    eduvpn-cli configure "Technische Universität München (TUM)"
    echo "Run \"eduvpn-cli activate\" to activate the vpn. Then check https://dnsleaktest.com"
fi


# INSTALL WINE
if [ $WINE = 1 ]; then
    # https://wiki.cockos.com/wiki/index.php/Installing_and_configuring_WineASIO
    echo "Installing wine, wineasio, winetricks"
    sudo pacman -S wine wine-gecko wine-mono wineasio winetricks
    echo "Creating wineprefix in $WINE_DIR"
    WINEPREFIX=$WINE_DIR winecfg
    echo "Installing wineasio config"
    regedit wineasio.cfg
fi
    

# INSTALL JACK AUDIO
if [ $JACK = 1 ]; then
    echo "Installing jack"
    sudo pacman -S jack2 jack2-dbus qjackctl pulseaudio-jack
    echo "Installing QJackCtl config"
    $CONFIG_SYNC jack
fi
