#!/bin/zsh
# comments
# lynx - Browser
# qrencode - QRCodes
# htop - task manager
# ripit rip audio dc: -c 1 -> lame, 2 -> flac, -o Output path
# cmatrix

# Prompt
# PS1="%{%F{red}%}%n%{%f%}@%{%F{blue}%}%m %{%F{yellow}%}%~ %{$%f%} "
PS1="[%D{%L:%M}|%F{yellow}%B%n%b%f|%F{yellow}%2~%f]%(!.#.>)"

# load aliases
. ~/.aliasrc

# Willkommensnachricht
toilet -F border -f term --gay Willkommen matth@mquarch!
neofetch

# Use ranger to switch directories and bind it to ctrl-o
ecd () {
    tmp="$(mktemp)"
    ranger --choosedir="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

bindkey -s '^o' 'ecd\n'

# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd
unsetopt beep notify
bindkey -v
# End of lines configured by zsh-newuser-install

# autocomplete
autoload -Uz compinit
zstyle ':completion:*' menu select
# zstyle :compinstall filename '/home/matth/.zshrc'
compinit
# include hidden
_comp_options+=(globdots)


# load zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

