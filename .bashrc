#########################################
#                                       #
# Customized .bashrc template file      #
#                                       #
#########################################


#
# Functions/Aliases for git operations
#

# Function for checking out specific PR/MR into new branch locally from github/gitlab repo
function git-checkout-pr () {

    # Either specify a remote, or just use origin
    if [[ $# -ne 1 ]];
    then
        REMOTE_NAME=$1
    else
        REMOTE_NAME=origin
    fi

    # Get the exact URL of the selected remote
    REMOTE_URL=$(git remote -v | grep $REMOTE_NAME | awk)

    # Generate a branch name for our PR
    NEW_BRANCH_NAME=pr-$1-$REMOTE_NAME

    # Check if our remote is a github or gitlab one
    if [[ "github" == *"$REMOTE_URL"* ]];
    then
        PR_NAME="pull"
    else
        PR_NAME="merge"
    fi

    # Fetch changes for PR, and checkout into new branch
    git fetch $REMOTE_NAME $PR_NAME/$1/head
    git checkout -b $NEW_BRANCH_NAME FETCH_HEAD

}