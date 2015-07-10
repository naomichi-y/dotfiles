#!/bin/bash

curdir=$(pwd)

# Setup vim
ln -s $curdir/.vim ~/.vim
ln -s $curdir/.vimrc ~/.vimrc
$curdir/.vim/bundle/neobundle.vim/bin/neoinstall

# Setup git
ln -s $curdir/.gitconfig ~/.gitconfig

echo 'Install success.'
