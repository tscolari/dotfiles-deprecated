# Bundler
alias be="bundle exec"
alias bes="bundle exec spec"

# tmux
alias tx='tmux'
alias txa='tmux attach -t'
alias txn='tmux new -s'
alias txs='tmux switch -t'

# Show human friendly numbers and colors
alias df='df -h'
alias ll='ls -alGh'
alias ls='ls -Gh'
alias du='du -h -d 2'

# Rspec
alias rs='rspec spec'

################
# Global aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g C='| wc -l'
alias -g H='| head'
alias -g L="| less"
alias -g N="| /dev/null"
alias -g S='| sort'
alias -g G='| grep' # now you can do: ls foo G something

# Functions
#
# (f)ind by (n)ame
# usage: fn foo
# to find all files containing 'foo' in the name
function fn() { ls **/*$1* }

# Goes to the root path of the git repository
function cd_() { cd "$(git rev-parse --show-toplevel)" }
