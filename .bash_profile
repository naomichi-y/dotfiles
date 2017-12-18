PS1='\W\$ '

eval "$(nodenv init -)"
eval "$(rbenv init -)"
eval "$(direnv hook bash)"

alias vi=/usr/local/bin/vim
alias slt='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias ll='ls -la'
alias docker-prune="docker system prune -f"

export EDITOR=vi
export HOMEBREW_BREWFILE=~/Brewfile

if [ -f ~/.bash_profile_local ]; then
  . ~/.bash_profile_local
fi
