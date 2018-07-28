PS1='\W\$ '

# alias vi=/usr/local/bin/vim
alias slt='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias ll='ls -la'
alias docker-prune="docker system prune -f"

export EDITOR=vi

if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi

if [ -f ~/.bash_profile.local ]; then
  . ~/.bash_profile.local
fi
