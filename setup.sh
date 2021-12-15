#!/bin/bash
set -eu

DOTFILE_DIR=$(cd $(dirname $0);pwd)
SRC_DIR="${DOTFILE_DIR}/src"
TMP_DIR="${DOTFILE_DIR}/tmp"

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

#######################################################################
# OSの設定変更
#######################################################################
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

#######################################################################
# ~/.configディレクトリの作成
#######################################################################
echo 'Create ~/.config'
mkdir -p ~/.config

#######################################################################
# Homebrewのインストール
#######################################################################
echo 'Install Homebrew'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#######################################################################
# Powerlineのインストール
#######################################################################
echo 'Install Powerline'
pip3 install powerline-shell

echo 'Create ~/.config/powerline-shell'
confirm_delete ~/.config/powerline-shell
ln -s ${SRC_DIR}/.config/powerline-shell ~/.config

#######################################################################
# Rictyのインストール
#######################################################################
echo 'Install Ricty font'
brew tap sanemat/font
brew install ricty --with-powerline
cp -Rf /opt/homebrew/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf

#######################################################################
# .zshrcファイルの作成
#######################################################################
echo 'Create ~/.zshrc'
confirm_delete ~/.zshrc
ln -s ${SRC_DIR}/.zshrc ~/.zshrc

#######################################################################
# Brewfileファイルの作成とパッケージのインストール
#######################################################################
echo 'Create ~/Brewfile'
confirm_delete ~/Brewfile
ln -s ${SRC_DIR}/Brewfile ~/Brewfile
(cd $SRC_DIR; brew bundle)

#######################################################################
# Deinのインストール
#######################################################################
echo 'Install dein.vim'
mkdir ${TMP_DIR}
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ${TMP_DIR}/installer.sh
sh ${TMP_DIR}/installer.sh ~/.cache/dein
rm -Rf ${TMP_DIR}

echo 'Create ~/.config/nvim'
confirm_delete ~/.config/nvim
ln -s ${SRC_DIR}/.config/nvim ~/.config

#######################################################################
# ~/.gitconfigファイルの作成
#######################################################################
echo 'Setup ~/.gitconfig'
confirm_delete ~/.gitconfig
ln -s ${SRC_DIR}/.gitconfig ~/.gitconfig

echo 'Installation is completed.'
