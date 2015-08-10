#!/bin/bash

base_dir=$(cd $(dirname $0);pwd)
#curdir=$(pwd)

# Setup vim
ln -s $base_dir/.vim ~/.vim
ln -s $base_dir/.vimrc ~/.vimrc
$base_dir/.vim/bundle/neobundle.vim/bin/neoinstall

# Setup git
ln -s $base_dir/.gitconfig ~/.gitconfig

echo 'Install success.'
