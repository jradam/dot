#!/bin/bash

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
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias q='tmux kill-server'
alias e='explorer.exe'

# general shortcuts
alias v='nvim'
alias t='ts-node'

# python helpers
alias python='python3'

# edit dotfiles
alias s='current_dir=$PWD;cd $HOME/dotfiles;v .;cd $current_dir;'

# restart terminal
alias rs='exec bash'

# add info when doing operations
alias mv="mv -iv"
alias cp="cp -riv"
alias mkdir='mkdir -vp'

# download file from URL
alias dl='curl -LO'

# delete junk 'zone identifier' files
alias dz='cd ~ && find . -name "*:Zone.Identifier" -type f -delete' 
