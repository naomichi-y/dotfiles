#############################################################
# ZSH
#############################################################

PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "

setopt no_beep

# ヒストリ
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt share_history

# 補完
setopt correct
autoload -Uz compinit
compinit -u
zstyle ':completion:*:default' menu select=1

if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt list_packed
zstyle ':completion:*' list-colors ''

alias ll='ls -la'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias cat='cat -n'
alias less='less -NM'
alias c='clear'

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

#############################################################
# Homebrew
#############################################################
if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi

#############################################################
# EXPORT
#############################################################
export LANG=ja_JP.UTF-8
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad
