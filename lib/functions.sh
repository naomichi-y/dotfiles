#!/bin/sh
set -eu

confirm_delete() {
  if [ -e $1 -o -L $1 ]; then
    echo "$1 is exists. do you want to overwrite? (y/n)"
    read answer

    if [ $answer == 'y' ]; then
      rm $1
    else
      exit 1;
    fi
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

setup_tmux_conf() {
  echo 'Setup ~/tmux.conf'

  if [ `which tmux` ]; then
    confirm_delete ~/.tmux.conf
    ln -s $REPO_PATH/.tmux.conf ~/.tmux.conf

    confirm_delete ~/.tmux
    ln -s $REPO_PATH/.tmux ~/.tmux

    if [ -d ~/.tmux/plugins/tpm ]; then
      rm -Rf ~/.tmux/plugins/tpm
    fi

    git clone https://github.com/tmux-plugins/tpm $REPO_PATH/.tmux/plugins/tpm
    tmux source ~/.tmux.conf
  else
    echo 'tmux command is not found.'
  fi
}

