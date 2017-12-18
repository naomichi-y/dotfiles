#!/bin/sh
set -eu

confirm_delete() {
  if [ -e $1 ]; then
    echo "$1 is exists. do you want to overwrite? (y/n)"
    read answer

    if [ $answer == 'y' ]; then
      rm $1
    else
      exit 1;
    fi
  else
    echo 3
    echo $1
  fi
}

setup_bash_profile() {
  echo 'Setup ~/.bash_profile'
  confirm_delete ~/.bash_profile

  ln -s $REPO_PATH/.bash_profile ~/.bash_profile
  echo 'Create ~/.bash_profile'
}

setup_vimrc() {
  echo 'Setup ~/.vimrc'
  confirm_delete ~/.vim
  ln -s $REPO_PATH/.vim ~/.vim

  confirm_delete ~/.vimrc
  ln -s $REPO_PATH/.vimrc ~/.vimrc

  if [ -d $REPO_PATH/.vim/dein/repos/github.com/Shougo/dein.vim ]; then
    rm -Rf $REPO_PATH/.vim/dein/repos/github.com/Shougo/dein.vim
  fi

  git clone https://github.com/Shougo/dein.vim.git $REPO_PATH/.vim/dein/repos/github.com/Shougo/dein.vim
}

setup_gitconfig() {
  echo 'Setup ~/.gitconfig'
  confirm_delete ~/.gitconfig
  ln -s $REPO_PATH/.gitconfig ~/.gitconfig
}
