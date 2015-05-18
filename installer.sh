#!/bin/bash

curdir=$(pwd)

# setup vim
ln -s $curdir/.vim ~/.vim
ln -s $curdir/.vimrc ~/.vimrc
$curdir/.vim/bundle/neobundle.vim/bin/neoinstall

# setup git
ln -s $curdir/.gitconfig ~/.gitconfig

echo 'Install success.'
