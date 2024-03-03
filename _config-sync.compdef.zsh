#compdef config-synk
_config-sync()
{
    _arguments \
        {-h,--help}'[Show a list of arguments]' \
        '--settings[Show the current settings]' \
        {-b,--backup}'[Copy dotfiles to `local` branch and merge into `main`]' \
        {-u,--update}'[Copy dotfiles to `local`, merge `main` into `local` and copy `local` files into the system]' \
        {-a,--all}'[Apply operation to all dotfiles]' \
        {-e,--exclude}'[Interpret all given strings as blacklist, not whitelist]' \
        '--pull[Pull `main` from a remote repository]' \
        '--push[Push `main` to a remote repository]' \
        '-U[`--pull -u --push`]' \
        '-B[`--pull -b --push`]' \
        '*:file or directory:_files'
}
_config-sync $@
