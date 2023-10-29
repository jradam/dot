#!/bin/bash

# TODO ----------------------------- Old aliases, remove unused

# auto cd when type dir name
shopt -s autocd

# ls and grep with color support
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ls shortcuts
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# other utilities
alias c='clear'
alias d='cd'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias v='nvim'
alias q='tmux kill-server'
alias e='explorer.exe'

# edit config files
alias s='current_dir=$PWD;cd $HOME/dotfiles;v .;cd $current_dir;'

# restart terminal
alias rs='exec bash'

# add info when doing operations
alias mv="mv -iv"
alias cp="cp -riv"
alias mkdir='mkdir -vp'

# show disk usage
alias df='df -h'

# download file from URL
alias dl='curl -LO'

# alert alias for long running commands. Use like: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# git
function gd() {
  git diff "$@" | diff-so-fancy | less -RFX
}



