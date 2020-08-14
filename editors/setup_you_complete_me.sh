#!/bin/bash


# Setup Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cat > ~/.vimrc <<- EOM
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')



" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'


Plugin 'ycm-core/YouCompleteMe'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
EOM


sudo apt install build-essential cmake python3-dev -y

STATUS=$(echo $?)

if [ $STATUS != "0" ];
then
    sudo dnf install cmake gcc-c++ make python3-devel -y
    STATUS=$(echo $?)
fi



if [ $STATUS != "0" ];
then
    yum install cmake gcc-c++ make python3-devel -y
fi


vim +PluginInstall +qall

cd ~/.vim/bundle/YouCompleteMe
python3 install.py --all


