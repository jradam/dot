#!/bin/bash

# Viewing
alias ls='ls --color=auto'
alias la='ls -ACF --color=auto'
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

r() { # Quick runner for TS, JS, and Python
  local file="$1"
  if [ -z "$file" ]; then
    for f in {main,init,index}.{ts,js,py}; do
      [ -f "$f" ] && { file="$f"; break; }
    done
    [ -z "$file" ] && { echo "No main/init/index file found."; return 1; }
  fi
  case "${file##*.}" in
    ts) node --no-warnings "$file" ;;
    js) node "$file" ;;
    py) python3 "$file" ;;
    *) echo "Unsupported file: ${file##*.}"; return 1 ;;
  esac
}
