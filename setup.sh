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

readonly DOTFILE_DIR=$(cd "$(dirname "$0")"; pwd)
readonly SRC_DIR="${DOTFILE_DIR}/src"
readonly TMP_DIR="${DOTFILE_DIR}/tmp"

export PATH=/opt/homebrew/bin:$PATH

AUTO_YES=false
if [ "${1:-}" = "-y" ] || [ "${1:-}" = "--yes" ]; then
  AUTO_YES=true
fi

confirm_delete() {
  if [ -e "$1" -o -L "$1" ]; then
    if [ "$AUTO_YES" = true ]; then
      rm -rf "$1"
    else
      echo "$1 already exists. do you want to overwrite? (y/n)"
      read answer </dev/tty

      if [ "$answer" = 'y' ]; then
        rm -rf "$1"
      else
        exit 1;
      fi
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
  if command -v brew &>/dev/null; then
    echo 'Homebrew already installed. Skipping.'
    return
  fi
  echo 'Install Homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

######################################################################
# Powerlineのインストール
######################################################################
setup_powerline() {
  echo 'Install Powerline'

  confirm_delete ~/.venv
  python3 -m venv ~/.venv
  source ~/.venv/bin/activate

  pip3 install powerline-shell

  echo 'Create ~/.config/powerline-shell'
  confirm_delete ~/.config/powerline-shell
  ln -s ${SRC_DIR}/.config/powerline-shell ~/.config/powerline-shell
}

######################################################################
# HackGenのインストール
######################################################################
setup_hackgen() {
  if [ "$OS_TYPE" = "Mac" ]; then
    echo 'Install HackGen font'
    mkdir -p ${TMP_DIR}
    local version=$(curl -s https://api.github.com/repos/yuru7/HackGen/releases/latest | grep '"tag_name"' | sed 's/.*"tag_name": "\(.*\)".*/\1/')
    curl -L "https://github.com/yuru7/HackGen/releases/download/${version}/HackGen_${version}.zip" -o "${TMP_DIR}/HackGen.zip"
    unzip "${TMP_DIR}/HackGen.zip" -d "${TMP_DIR}"
    cp "${TMP_DIR}/HackGen_${version}"/*.ttf ~/Library/Fonts/
    rm -Rf ${TMP_DIR}
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
  printf '1\n2\n' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Shougo/dein-installer.vim/master/installer.sh)"

  echo 'Create ~/.config/nvim'
  confirm_delete ~/.config/nvim
  ln -s ${SRC_DIR}/.config/nvim ~/.config/nvim
}

######################################################################
# Rubyのインストール
######################################################################
readonly RUBY_VERSION='3.3'

setup_ruby() {
  echo 'Install Ruby'
  eval "$(rbenv init -)"
  rbenv install --skip-existing "${RUBY_VERSION}"
  rbenv global "${RUBY_VERSION}"
}

#######################################################################
# AWS Session Manager Pluginのインストール
#######################################################################
setup_session_manager_plugin() {
  if [ "$OS_TYPE" != "Mac" ]; then
    return
  fi
  echo 'Setup AWS Session Manager Plugin'
  mkdir -p ${TMP_DIR}
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "${TMP_DIR}/sessionmanager-bundle.zip"
  unzip "${TMP_DIR}/sessionmanager-bundle.zip" -d "${TMP_DIR}"
  sudo "${TMP_DIR}/sessionmanager-bundle/install" -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
  rm -Rf ${TMP_DIR}
}

setup_os
setup_homebrew
setup_powerline
setup_hackgen
setup_brew
setup_ruby
setup_dein
setup_session_manager_plugin
