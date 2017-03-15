PS1='\u@\w\$ '

eval "$(nodenv init -)"
eval "$(rbenv init -)"
eval "$(direnv hook bash)"

alias vi=/usr/local/bin/vim
alias slt='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias ll='ls -la'

export EDITOR=vi
export HOMEBREW_BREWFILE=~/Brewfile
