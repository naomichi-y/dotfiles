#!/bin/bash
set -eu

confirm_delete() {
  if [ -e $1 -o -L $1 ]; then
    echo "$1 is exists. do you want to overwrite? (y/n)"
    read answer

    if [ $answer = 'y' ]; then
      rm $1
    else
      exit 1;
    fi
  fi
}

setup_init() {
  echo 'Install Homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'Install Powerline'
  pip3 install powerline-shell

  echo 'Install Ricty font'
  brew tap sanemat/font
  brew install ricty --with-powerline
  cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
  fc-cache -vf
}

setup_config() {
  echo 'Create ~/.zshrc'
  confirm_delete ~/.zshrc
  ln -s ${BASE_PATH}/.zshrc ~/.zshrc

  echo 'Create Brewfile'
  confirm_delete ~/Brewfile
  ln -s ${BASE_PATH}/Brewfile ~/Brewfile
}

setup_neovim() {
  echo 'Install neovim'
  brew install neovim

  echo 'Install required libraries'
  pip3 install -U msgpack-python

  mkdir -p ~/.config
  confirm_delete ~/.config/nvim
  ln -s ${BASE_PATH}/.config/nvim ~/.config

  echo 'Install deain.vim'
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
  sh ./installer.sh ~/.cache/dein
  rm -f ./installer.sh

  echo 'Install n'
  brew install n
  sudo n stable
}

setup_gitconfig() {
  echo 'Setup ~/.gitconfig'
  confirm_delete ~/.gitconfig
  ln -s ${BASE_PATH}/.gitconfig ~/.gitconfig
}

setup_tmux_conf() {
  echo 'Setup ~/tmux.conf'

  if [ `which tmux` ]; then
    confirm_delete ~/.tmux.conf
    ln -s ${BASE_PATH}/.tmux.conf ~/.tmux.conf

    confirm_delete ~/.tmux
    ln -s ${BASE_PATH}/.tmux ~/.tmux

    if [ -d ~/.tmux/plugins/tpm ]; then
      rm -Rf ~/.tmux/plugins/tpm
    fi

    git clone https://github.com/tmux-plugins/tpm ${BASE_PATH}/.tmux/plugins/tpm
    tmux source ~/.tmux.conf
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
  else
    echo 'tmux command is not found.'
  fi
}

readonly BASE_PATH=$(cd $(dirname $0);pwd)

setup_init
setup_config
setup_neovim
setup_gitconfig
# setup_tmux_conf

echo 'Installation is completed.'
