#!/bin/bash
# Copyright  ©  2022  Matthias  Quintern.
# This software comes with no warranty.
# This software is licensed under the GPL3

# ABOUT
# Copies all (dot)files listed in user_dotfiles and system_dotfiles to REPO_DIR
# If you pass strings as parameters, only dotfiles that contain at least one of the strings are processed.

#
# UTILITY
#
FMT_MESSAGE="\e[1;34m%s\e[0m\n"
FMT_ERROR="\e[1;31mERROR: \e[0m%s\n"
FMT_GITERROR="\e[1;31mERROR\e[0m while performing a git operation: %s - \e[1;31mmanual intervention might be required\e[0m\n"
FMT_BACKUP="\e[1;32mBacking Up:\e[0m %s\n"
FMT_UPDATE="\e[1;33mUpdating:\e[0m %s\n"
FMT_CONFIG="\e[34m%s\e:\t\e[1;33m%s\e[0m\n"
error() {
    printf "$FMT_ERROR" "$@" >&2
    exit 1
}
git_error() {
    printf "$FMT_GITERROR" "$@" >&2
    exit 2
}
msg() {
    printf "$FMT_MESSAGE" "$@"
}

# LOAD SETTINGS
config_file="$HOME/.config/config-sync.conf"
if [[ ! -f $config_file ]]; then
    error "Could not find config file '$config_file'."
    msg "You can copy the template from /usr/share/config-sync/ to ~/.config and edit it to your liking."
    exit 1
fi
source $config_file

#
# FILE COPYING
#
INCLUDE=1  # 1: Include mode, 0: exclude mode
# check if a passed parameter is contained in file
check_file_in_args()
{
    if [[ $ALL = 1 ]]; then
        return 0
    fi
    for string in ${FILES[@]}; do
        if [[ $file == *$string* ]]; then
            if [[ $INCLUDE == 1 ]]; then  # is 0=true when in include mode
                return 0
            else
                return 1
            fi
        fi
    done
    if [[ $INCLUDE = 0 ]]; then
        return 0
    else
        return 1
    fi
}


_copy_files_to_repo() {
    # make directories 
    mkdir -p $REPO_DIR/home
    mkdir -p $REPO_DIR/etc

    for file in "${user_dotfiles[@]}"; do
        if check_file_in_args; then
            printf "$FMT_BACKUP" "$file"
            rsync -aR $file $REPO_DIR/home
        fi
    done

    for file in "${system_dotfiles[@]}"; do
        if check_file_in_args; then
            printf "$FMT_BACKUP" "$file"
            sudo rsync -aR $file $REPO_DIR/etc

            # sudoers permissions
            if [[ $file == "/etc/./sudoers" ]]; then
                msg "Warning: Making sudoers readable for users (necessary for push/pull, but potential security risk)."
                sudo chmod a+r $REPO_DIR/etc/sudoers
            fi
        fi
    done
    sudo chown -R ${CS_USER}:${CS_GROUP} $REPO_DIR
}


_copy_files_from_repo() {
    mkdir -p $BACKUP_DIR/home &&
    mkdir -p $BACKUP_DIR/etc || {
        error "Can not create backup directories, exiting now. No installed file will be updated."
        exit 1
    }

    for file in "${user_dotfiles[@]}"; do
        if check_file_in_args; then
            mkdir -p $(dirname $file)
            file=$(echo $file | sed "s|.*/\./||") # remove ~/./ from the filename
            printf "$FMT_UPDATE" "$file"
            rsync -a --delete --backup-dir $BACKUP_DIR/home $REPO_DIR/home/$file $HOME/$file
        fi
    done

    for file in "${system_dotfiles[@]}"; do
        if check_file_in_args; then
            mkdir -p $(dirname $file)
            file=$(echo $file | sed "s|/etc/||") # remove /etc/ from the filename
            printf "$FMT_UPDATE" "$file"

            # sudoers permissions, must come before copying sudoers since sudo doesnt work when owned by user
            if [ $file == "./sudoers" ]; then
                sudo chown root:root $REPO_DIR/etc/sudoers
                sudo chmod 0600 $REPO_DIR/etc/sudoers
            fi

            sudo rsync -a --backup-dir $BACKUP_DIR/etc $REPO_DIR/etc/$file /etc/$file

            # change ownership to root
            sudo chown root:root /etc/$file

            # change sudoers perms back
            if [ $file == "./sudoers" ]; then
                # msg "Making sudoers in system readable only for root"
                sudo chown $CS_USER:$CS_GROUP $REPO_DIR/etc/sudoers
            fi

        fi
    done
    sudo chown -R ${CS_USER}:${CS_GROUP} $BACKUP_DIR
}


#
# SAVE CONFIGS
#
# copy configs from arrays in $REPO_DIR
save_configs()
{
    git branch local &> /dev/null
    git checkout local || git_error "checkout 'local' branch" 

    _copy_files_to_repo

    if [[ $(git status -s | wc -l) -gt 0 ]]; then
        git add -A
        git commit -a || error "commit local"
    fi

    git checkout main || error "checkout 'main' branch"

    git merge local || {
        git mergetool &&
        git merge --continue
    } || error "merging local into main branch"
}



#
# UPDATE CONFIGS
#
update_configs() {
    git branch local &> /dev/null
    git checkout local || git_error "checkout 'local' branch" 

    _copy_files_to_repo

    git add -A
    git commit -am "update repo with local files"

    git merge main || {
        git mergetool &&
        git merge --continue
    } || git_error "merging main into local branch"

    _copy_files_from_repo
}



#
# REPO MANAGEMENT
#
# check if pwd is root of git repo
check_git_repo() {
    if [[ -d .git ]]; then
        return 0
    else
        return 1
    fi
}

check_rsync() {
    if ! command -v rsync &> /dev/null; then
        error "rsync is not installed. Please install rsync."
        exit 1
    fi
}

check_git() {
    if ! command -v git &> /dev/null; then
        error "git is not installed. Please install git."
        exit 1
    fi
}

git_init() {
    echo -e "# Dotfiles repository\nThis repo is managed by "'`config-sync`' > "README.md"
    git init --initial-branch main &&
    git add -A &&
    git commit -m "initial commit" || git_error "initializing repo"

    if [ -n "$GIT_REMOTE" ]; then 
        msg "Adding origin: $GIT_REMOTE" &&
        git remote add origin "$GIT_REMOTE" || git_error "adding origin '$GIT_REMOTE'"
    else
        printf "$FMT_WARNING" "Not adding a remote since '\$GIT_REMOTE' variable is not set. You will have to add one manually if you want to sync to a remote repository."
    fi
}

git_push() {
    msg "Pushing repo" &&
    git checkout main || git_error "checkout 'main' branch"
    git push -u origin main || git_error "pushing main branch to origin"
}


git_pull() {
    msg "Pulling repo"
    git checkout main || git_error "checkout 'main' branch"
    git pull origin main || git_error "pulling main branch from origin"
}


#
# REMOTE SERVER
#
remote_push() {
    msg "Pushing to remote: $REMOTE_DIR"
    rsync -avu -e "ssh -p $REMOTE_PORT" $REPO_DIR/ $REMOTE_DIR ||
    error "Something went wrong: Could not push to remote."
}

remote_pull() {
    msg "Pulling from remote: $REMOTE_DIR"
    rsync -avu -e "ssh -p $REMOTE_PORT" $REMOTE_DIR/ $REPO_DIR ||
    error "Something went wrong: Could not pull from remote."
}
    

#
# HELP
#
show_help() {
    printf "\e[34mFlags:\e[33m
Argument        Short   Install:\e[0m
--help          -h      show this
--settings      -s      show current settings

--backup        -b      copy dotfiles to \$REPO_DIR
--update        -u      copy dotfiles from \$REPO_DIR into the system, current dotfiles are backed up to \$BACKUP_DIR
--all           -a      apply operation to all dotfiles, overrides --exclude
--exclude       -e      interpret all given strings as blacklist, not whitelist

--pull                  pull dotfiles from git repo
--push                  push dotfiles to git repo      

                -U      short for --pull -u
                -B      short for --pull -b --push

Any argument without a '-' is interpreted as part of a filepath/name and the selected operation will only be applied to files containing the given strings.
The order for multiple actions is: pull -> backup -> update -> push
Pull/Push operations always affect all the files in the \$REPO_DIR, but not the files that are actually installed.
"
}


show_settings() {
    printf "\e[1mThe current settings are:\e[0m\n"
    printf "$FMT_CONFIG" \$REPO_DIR "$REPO_DIR"
    printf "$FMT_CONFIG" \$BACKUP_DIR "$BACKUP_DIR"
    printf "$FMT_CONFIG" \$GIT_REPO "$GIT_REPO"
    printf "$FMT_CONFIG" \$REMOTE_DIR "$REMOTE_DIR"
    printf "$FMT_CONFIG" \$REMOTE_PORT "$REMOTE_PORT"
}


#
# PARSE ARGS
#
if [ -z $1 ]; then
    show_help
    exit 0
fi



BACKUP=0
UPDATE=0
GIT_PULL=0
GIT_PUSH=0
REMOTE_PULL=0
REMOTE_PUSH=0
ALL=0
# all command line args with no "-" are interpreted as part of filepaths. 
FILES=""
while (( "$#" )); do
    case "$1" in
        -h|--help)
            show_help
            exit 0 ;;
        -s|--settings)
            show_settings
            exit 0 ;;
        -b|--backup)
            BACKUP=1
            shift ;;
        -B)
            BACKUP=1
            GIT_PULL=1
            GIT_PUSH=1
            shift ;;
        -u|--update)
            UPDATE=1
            shift ;;
        -U)
            UPDATE=1
            GIT_PULL=1
            GIT_PUSH=1
            shift ;;
        -a|--all)
            ALL=1
            shift ;;
        -e|--exclude)
            INCLUDE=0
            shift ;;
        --pull)
            GIT_PULL=1
            shift ;;
        --push)
            GIT_PUSH=1
            shift ;;
        -*|--*=) # unsupported flags
            error "Unsupported flag $1"
            exit 1 ;;
        *) # everything that does not have a - is interpreted as filepath
            FILES="$FILES $1"
            shift ;;
    esac
done

if [ $BACKUP = 1 ] && [ $UPDATE = 1 ]; then
    error "Invalid arguments: can not backup and update at the same time"
fi


# 
# RUN THE FUNCTIONS
#
# create and cd REPO_DIR
cd $REPO_DIR 2>/dev/null || {
    msg "Creating $REPO_DIR"
    mkdir -p $REPO_DIR
    cd $REPO_DIR ||  error "Can not create config dir: $REPO_DIR" 
}

# check if config_dir is a git repo
if ! check_git_repo; then
    msg "Initializing git repo in $PWD"
    git_init
fi

check_git
check_rsync

# ordered
if [ $GIT_PULL = 1 ]; then
    git_pull
fi
if [ $BACKUP = 1 ]; then
    save_configs
fi
if [ $UPDATE = 1 ]; then
    update_configs
fi
if [ $GIT_PUSH = 1 ]; then
    git_push
fi
