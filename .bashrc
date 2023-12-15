# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$PATH:$HOME/.local/bin:$HOME/bin"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# SSH aliases
function ssh-w-jump () {
    ssh -Y -J ssh.nsls2.bnl.gov jwlodek@$1
}

alias back="cd $OLDPWD"

alias ip='ip -c a'
alias explorer='nautilus'

function scp-w-jump() {
    echo "Copying $1 over ssh..."
    scp -J ssh.nsls2.bnl.gov $1 jwlodek@$2
}

alias css='run-css -w ~/Workspace/css-workspace'

function prune-branches () {
    CURRENT_BRANCH=$(git branch --show-current)
    echo "Current branch is $CURRENT_BRANCH. Syncing with origin..."
    git pull origin $CURRENT_BRANCH
    echo "Trimming any branches that don't have a diff to $CURRENT_BRANCH..."
    BRANCHES=$(git for-each-ref --format='%(refname:short)' refs/heads/)
    (IFS='
    '
    for BRANCH in $BRANCHES; do
        if [[ "$BRANCH" != "$CURRENT_BRANCH" && "$BRANCH" != "production" && "$BRANCH" != "main" && "$BRANCH" != "master" ]];
        then
            echo "Checking diff for branch: $BRANCH..."
            NUM_DIFF=$(git log $CURRENT_BRANCH..$BRANCH | wc -l)
            if [[ "$NUM_DIFF" == "0" ]];
            then
                echo "Found no unmerged commits on branch $BRANCH, deleting..."
                git branch -d $BRANCH
            fi
            
        fi
    done)
    echo "Done."
}


# Utility functions

function manage-iocs () {

    case $1 in
        lastlog|status|version|report|help|nextport|list|attach) /usr/bin/manage-iocs $@;;
        *) echo "Detected subcommand that requires elevated privelages..."
           sudo /usr/bin/manage-iocs $@;;
    esac
}


function run-ansible-local() {
    ansible-playbook -K --connection=local --inventory=dell-rhel8, $1
}



function run-on-dirs () {

    echo "Running $@ with all directories in $PWD as inputs..."

    find . -maxdepth 1 -type d \( ! -name . \) -exec bash -c " $@ '{}' " \;
}

function run-in-dirs () {

    echo "Running command $@ in all directories in $PWD..."

    find . -maxdepth 1 -type d \( ! -name . \) -exec bash -c " cd '{}' && $@ " \;
}


function generate-ioc () {
    makeBaseApp.pl -t ioc "$@"
    makeBaseApp.pl -i -t "$@"
}

export EDITOR="vim"

# TLDR pages setup
export TLDR_COLOR_NAME="cyan"
export TLDR_COLOR_DESCRIPTION="white"
export TLDR_COLOR_EXAMPLE="green"
export TLDR_COLOR_COMMAND="red"
export TLDR_COLOR_PARAMETER="white"
export TLDR_LANGUAGE="es"
export TLDR_CACHE_ENABLED=1
export TLDR_CACHE_MAX_AGE=720
export TLDR_PAGES_SOURCE_LOCATION="https://raw.githubusercontent.com/tldr-pages/tldr/master/pages"
export TLDR_DOWNLOAD_CACHE_LOCATION="https://tldr-pages.github.io/assets/tldr.zip"

# Set Path and Library path
export PATH=~/.local/bin:/var/lib/snapd/snap/bin:$PATH
export LD_LIBRARY_PATH=~/.local/lib:$LD_LIBRARY_PATH
export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault_password

export EPICS_CA_ADDR_LIST="127.0.0.1"

function clone-and-venv () {
    
    # Handle help command
    if [[ "$@" = *"-h"* ]] || [[ "$@" = *"--help"* ]] || [[ $# -ne 1 && $# -ne 2 ]];
    then
        echo "Command takes one or two arguments."
        echo "First argument is always the git url of the repository in question."
        echo "Second (optional) argument is a branch name if desired."
        echo
        echo "Examples:"
        echo
        echo "    clone-and-venv https://github.com/jwlodek/py_cui"
        echo "    clone-and-venv https://github.com/jwlodek/pyautogit v0.1.5-devel"
        return 0
    fi

    TARGET_URL=$1
    CLONED_DIRNAME=$(echo $TARGET_URL | awk -F/ '{print $NF}')
    echo "$CLONED_DIRNAME"

    if [ "$#" = 2 ];
    then
    git clone --single-branch --branch=$2 $TARGET_URL
    else
        git clone $TARGET_URL
    fi

    # Enter cloned directory and create venv
    cd $CLONED_DIRNAME
    mkdir venv
    python3 -m venv venv/
    source venv/bin/activate

    # Update venv pip version and install requirements.
    python3 -m pip install --upgrade pip
    pip3 install -r requirements.txt --exists-action i
    pip3 install -r requirements_dev.txt --exists-action i
    pip3 install -r requirements-dev.txt --exists-action i
    
}
