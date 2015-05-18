#!/bin/bash

curdir=$(pwd)

ln -s $curdir/.vim ~/.vim
ln -s $curdir/.vimrc ~/.vimrc
$curdir/.vim/bundle/neobundle.vim/bin/neoinstall

echo 'Install success.'
