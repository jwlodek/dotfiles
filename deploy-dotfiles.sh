#!/bin/bash

# Helper script for deploying dotfile configurations on current machine

# First, clean up existing dotfiles

rm $HOME~/.nanorc
rm $HOME/.vimrc
rm $HOME/.gitconfig

cp editors/.vimrc $HOME/.vimrc
cp editors/.nanorc $HOME/.nanorc
cp vcs/.gitconfig $HOME/.gitconfig
