% CONFIG-SYNC(1) config-sync 2.0
% Matthias Quintern
% February 2024

# NAME
**config-sync** - easily backup and synchronize configuration files

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
**config-sync** uses *git* and *rsync* synchronize your dotfiles between devices.

A local git repository is created in `$REPO_DIR`. The `main` branch can be synchronized with a git remote.

When backing up the system dotfiles, the files are copied (using rsync) to the `local` branch.
The `local` branch is then merged into the `main` branch.

When updating the system dotfiles with the files from the repo, the files from the system are copied to the `local` branch.
Then, the `main` branch is merged into the `local` branch and the files from `local` branch are copied back into the system.

If merge conflicts occur, **config-sync** will run `git mergetool` to let you merge the files. Make sure a mergetool is configured.

# CONFIGURATION
The configuration is stored in ~/.config/config-sync.conf.
There is a template in /usr/share/config-sync/ which you can copy to your config directory and edit to your liking.

# OPTIONS
**-h**, **--help**
: Show a list of arguments.

**--settings**
: Show the current settings.

**-b**, **--backup**
: Copy dotfiles to `local` branch and merge into `main`

**-u**, **--update**
: Copy dotfiles to `local`, merge `main` into `local` and copy `local` files into the system

**-a**, **--all**
: Apply operation to all dotfiles

**-e,** **--exclude**
: Interpret all given strings as blacklist, not whitelist

**--pull**
: Pull `main` from a remote repository

**--push**
: Push `main` to a remote repository

**positional arguments**
: Pos. args are strings that have to be contained in a path in order for it to be synced. If no pos. args are given, all files are synced.

# TROUBLESHOOTING
If you get a 'Error while performing a git operation - manual intervention might be required' error message, you will probably need to manually merge or rebase.
This can happen, when backing up the dotfiles without pulling the (changed) remote first.
To solve a problem, go to into the `$REPO_DIR` and run the appropriate git commands.

# COPYRIGHT
Copyright  ©  2024  Matthias  Quintern.  License GPLv3+: GNU GPL version 3 <https://gnu.org/licenses/gpl.html>.\
This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law.
