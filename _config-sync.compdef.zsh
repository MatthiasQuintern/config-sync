#compdef config-synk
_config-sync()
{
    _arguments \
        {--backup,-b}'[Copy dotfiles to \$CONFIG_DIR]' \
        {--update,-u}'[Copy dotfiles from \$CONFIG_DIR into the system]' \
        {--all,-a}'[Apply operation to all dotfiles]' \
        {--git-pull}'[Pull dotfiles from git repo]' \
        {--git-push}'[push dotfiles to git repo]' \
        {--remote-pull}'[Pull dotfiles from remote location]' \
        {--remote-push}'[push dotfiles to remote location]' \
        {--settings,-s}'[Show current settings]' \
        {--help,-h}'[We all need it at times...]' \
        '*:file or directory:_files'
}
_config-sync $@
