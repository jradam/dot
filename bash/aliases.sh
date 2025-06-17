#!/bin/bash

# Viewing
alias ls='ls -A --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Navigation
alias c='clear'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'

# Shortcuts
alias v='nvim'
alias rs='exec bash'
alias q='tmux kill-server'
alias e='wsl-open'

# add info when doing operations
alias mv="mv -iv"
alias cp="cp -riv"
alias mkdir='mkdir -vp'

# delete junk 'zone identifier' files
alias dz='dir=$PWD; cd ~ && COUNT=$(find . -name "*:Zone.Identifier" -type f -print | wc -l); find . -name "*:Zone.Identifier" -type f -delete; echo "Deleted $COUNT"; cd $dir;'

# Expose wsl
alias expose='yes | npx expose-wsl@latest'

