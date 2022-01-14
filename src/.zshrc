if [ "$(uname)" = "Darwin" ]; then
  readonly OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
  readonly OS='Linux'
else
  echo "Unsupported platform."
  exit 1
fi

#############################################################
# ZSH
#############################################################
# 履歴
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
alias vi='nvim'
alias c='clear'
alias grep='grep --exclude-dir={.terraform,plugins}'

# timeコマンドの実行結果を読みやすくする
TIMEFMT=$'\n\n========================\nProgram : %J\nCPU     : %P\nuser    : %*Us\nsystem  : %*Ss\ntotal   : %*Es\n========================\n'

#############################################################
# Powerline
#############################################################
function powerline_precmd() {
PS1="
$(powerline-shell --shell zsh $?)
$ "

}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
  install_powerline_precmd
fi

#############################################################
# EXPORT
#############################################################
export CLICOLOR=1
export PATH=~/bin:$PATH

if [ "$OS" = "Linux" ]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

#############################################################
# Load local setting
#############################################################
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
