#!/bin/zsh

set -eu

if [ "$(uname)" = "Darwin" ]; then
  readonly OS_TYPE='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
  readonly OS_TYPE='Linux'
else
  echo "Unsupported platform."
  exit 1
fi

readonly DOTFILE_DIR=$(cd $(dirname $0);pwd)
readonly SRC_DIR="${DOTFILE_DIR}/src"
readonly TMP_DIR="${DOTFILE_DIR}/tmp"

export PATH=/opt/homebrew/bin:$PATH

confirm_delete() {
  if [ -e $1 -o -L $1 ]; then
    echo "$1 is exists. do you want to overwrite? (y/n)"
    read answer

    if [ $answer = 'y' ]; then
      rm -rf $1
    else
      exit 1;
    fi
  fi
}

######################################################################
# .envのコピー
######################################################################
if [ ! -e .env ]; then
  echo '.env file needs to be created.'
fi

confirm_delete ~/.env
cp .env ~/.env

######################################################################
# OSの設定変更
######################################################################
setup_os() {
  if [ "$OS_TYPE" = "Mac" ]; then
    echo 'Setup system settings'

    # キーリピート開始までの認識速度
    defaults write NSGlobalDomain InitialKeyRepeat -int 13

    # キーリピートの速度
    defaults write -g KeyRepeat -int 1

    # 隠しファイルを表示
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Finderでパスを表示
    defaults write com.apple.finder ShowPathbar -bool true

    # Finderでステータスバーを表示
    defaults write com.apple.finder ShowStatusBar -bool true

    # 通知バナーの表示時間
    defaults write com.apple.notificationcenterui bannerTime 10
  fi

  # .zshrcの作成
  echo 'Create ~/.zshrc'
  confirm_delete ~/.zshrc
  ln -s ${SRC_DIR}/.zshrc ~/.zshrc

  # .gitconfigの作成
  echo 'Setup ~/.gitconfig'
  confirm_delete ~/.gitconfig
  ln -s ${SRC_DIR}/.gitconfig ~/.gitconfig

  echo 'Installation is completed.'
}

######################################################################
# Homebrewのインストール
######################################################################
setup_homebrew() {
  echo 'Install Homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

######################################################################
# Powerlineのインストール
######################################################################
setup_powerline() {
  echo 'Install Powerline'

  python3 -m venv ~/.venv
  source ~/.venv/bin/activate

  sudo pip3 install powerline-shell

  echo 'Create ~/.config/powerline-shell'
  confirm_delete ~/.config/powerline-shell
  ln -s ${SRC_DIR}/.config/powerline-shell ~/.config
}

######################################################################
# Rictyのインストール
######################################################################
setup_ricty() {
  if [ "$OS_TYPE" = "Mac" ]; then
    echo 'Install Ricty font'
    brew tap sanemat/font
    brew install ricty --with-powerline
    cp -Rf /opt/homebrew/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
    fc-cache -vf
  fi
}

######################################################################
# Brewfileファイルの作成とパッケージのインストール
######################################################################
setup_brew() {
  echo 'Create ~/Brewfile'
  confirm_delete ~/Brewfile
  ln -s ${SRC_DIR}/Brewfile ~/Brewfile
  (cd $SRC_DIR; brew bundle)
}

######################################################################
# Deinのインストール
######################################################################
setup_dein() {
  echo 'Install dein.vim'
  confirm_delete ~/.cache/dein
  mkdir -p ${TMP_DIR}
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Shougo/dein-installer.vim/master/installer.sh)"

#  echo 'Create ~/.cache/nvim'
#  ln -s ${SRC_DIR}/.config/nvim ~/.cache
}

#######################################################################
# AWS Session Manager Pluginのインストール
#######################################################################
setup_session_manager_plugin() {
  echo 'Setup AWS Session Manager Plugin'
  mkdir -p ${TMP_DIR}
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
  unzip sessionmanager-bundle.zip
  sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
  rm -Rf ${TMP_DIR}
}

#setup_os
#setup_homebrew
#setup_powerline
#setup_ricty
#setup_brew
#setup_dein
#setup_session_manager_plugin
