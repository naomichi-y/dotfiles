#!/bin/bash
set -eu

if [ "$(uname)" = "Darwin" ]; then
  readonly OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
  readonly OS='Linux'
else
  echo "Unsupported platform."
  exit 1
fi

readonly DOTFILE_DIR=$(cd $(dirname $0);pwd)
readonly SRC_DIR="${DOTFILE_DIR}/src"
readonly TMP_DIR="${DOTFILE_DIR}/tmp"

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
if [ "$OS" = "Mac" ]; then
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

######################################################################
# ~/.configディレクトリの作成
######################################################################
echo 'Create ~/.config'
mkdir -p ~/.config

######################################################################
# Homebrewのインストール
######################################################################
echo 'Install Homebrew'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

######################################################################
# Powerlineのインストール
######################################################################
echo 'Install Powerline'
sudo pip3 install powerline-shell

echo 'Create ~/.config/powerline-shell'
confirm_delete ~/.config/powerline-shell
ln -s ${SRC_DIR}/.config/powerline-shell ~/.config

######################################################################
# Rictyのインストール
######################################################################
if [ "$OS" = "Mac" ]; then
  echo 'Install Ricty font'
  brew tap sanemat/font
  brew install ricty --with-powerline
  cp -Rf /opt/homebrew/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
  fc-cache -vf
fi

######################################################################
# .zshrcファイルの作成
######################################################################
echo 'Create ~/.zshrc'
confirm_delete ~/.zshrc
ln -s ${SRC_DIR}/.zshrc ~/.zshrc

######################################################################
# Brewfileファイルの作成とパッケージのインストール
######################################################################
echo 'Create ~/Brewfile'
confirm_delete ~/Brewfile
ln -s ${SRC_DIR}/Brewfile ~/Brewfile
(cd $SRC_DIR; brew bundle)

######################################################################
# Deinのインストール
######################################################################
echo 'Install dein.vim'
mkdir ${TMP_DIR}
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ${TMP_DIR}/installer.sh
sh ${TMP_DIR}/installer.sh ~/.cache/dein
rm -Rf ${TMP_DIR}

echo 'Create ~/.config/nvim'
confirm_delete ~/.config/nvim
ln -s ${SRC_DIR}/.config/nvim ~/.config

######################################################################
# ~/.gitconfigファイルの作成
######################################################################
echo 'Setup ~/.gitconfig'
confirm_delete ~/.gitconfig
ln -s ${SRC_DIR}/.gitconfig ~/.gitconfig

echo 'Installation is completed.'

#######################################################################
# AWS Session Manager Pluginのインストール
#######################################################################
echo 'Setup AWS Session Manager Plugin'
mkdir ${TMP_DIR}
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
unzip sessionmanager-bundle.zip
sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
rm -Rf ${TMP_DIR}

#######################################################################
# tmuxの設定ファイルを作成
#######################################################################
confirm_delete ~/.tmux.conf
ln -s ${SRC_DIR}/.tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf
