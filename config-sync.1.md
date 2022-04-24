% CONFIG-SYNC(1) config-sync 1.0
% Matthias Quintern
% April 2022

# NAME
**config-sync** - easily backup and deploy configuration files

# SYNOPSIS
| Backup:
|    **config-sync** [OPTION...] -b PATHS...
|    **config-sync** [OPTION...] -b -a
|    **config-sync** [OPTION...] --git-push

| Deploy/Update:
|    **config-sync** [OPTION...] --git-pull
|    **config-sync** [OPTION...] -u PATHS...
|    **config-sync** [OPTION...] -u -a --diff

# DESCRIPTION
**config-sync** uses *rsync* to backup or deploy selected dotfiles.
They are always deployed from or backuped to a directory $CONFIG_DIR. 
They can also be pulled to or pushed from $CONFIG_DIR to/from a git repo or a remote location.

# CONFIGURATION
The configuration is stored in ~/.config/config-sync.conf.
There is a template in /usr/share/config-sync/ which you can copy to your config directory and edit to your liking.

# OPTIONS
**-h**, **--help**
: Show a list of arguments.

**--settings**
: Show the current settings.

**-b**, **--backup**
: Copy dotfiles to $CONFIG_DIR

**-u**, **--update**
: Copy dotfiles from $CONFIG_DIR into the system, current dotfiles are backed up to $BACKUP_DIR

**-a**, **--all**
: Apply operation to all dotfiles

**-e,** **--exclude**
: Interpret all given strings as blacklist, not whitelist

**--diff**
: Use vimdiff to merge the file in the filesystem with the new one (applies only to --update)

**--git-pull**
: Pull dotfiles from git repo to $CONFIG_DIR

**--git-push**
: Push dotfiles from $CONFIG_DIR to git repo

**--remote-pull**
: Pull dotfiles from remote location (eg. vps) to $CONFIG_DIR

**--remote-push**
: Push dotfiles from $CONFIG_DIR to remote location

**positional arguments**
: Pos. args are strings that have to be contained in a path in order for it to be synced. If no pos. args are given, all files are synced.

# COPYRIGHT
Copyright  ©  2022  Matthias  Quintern.  License GPLv3+: GNU GPL version 3 <https://gnu.org/licenses/gpl.html>.\
This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law.
