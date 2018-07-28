#############################################################
# ZSH
#############################################################

PROMPT='$ '

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

if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt list_packed
zstyle ':completion:*' list-colors ''

# エイリアス
alias ls='ls -aF'
alias ll='ls -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias cat='cat -n'
alias less='less -NM'

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
