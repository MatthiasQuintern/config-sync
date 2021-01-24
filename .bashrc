#
# ~/.bashrc
#
# comments
# lynx - Browser
# qrencode - QRCodes
# htop - task manager
# ripit rip audio dc: -c 1 -> lame, 2 -> flac, -o Output path
# cmatrix

# load aliases
. ~/.aliasrc


# Willkommensnachricht
toilet -F border -f term --gay Willkommen matth@mquarch!
neofetch

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

	
# Prompt
PS1='[\e[0;37m\A|\e[1;32mmatth\e[0m|\e[0;36m\w\e[0m]\e[0;34m\$\e[0m >'
