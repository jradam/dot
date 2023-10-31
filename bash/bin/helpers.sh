#!/bin/bash

source $HOME/dotfiles/bash/lib/colors.sh

print() {
  local type=$1
  local message=$2
  local color

  case $type in
    "echo") color=$PINK ;;
    "error") color=$RED ;;
    "info") color=$BLUE ;;
    "read") color=$ORANGE ;;
    "title") color=$GREEN ;;
    *) color=$PINK ;;
  esac

  if [ "$type" == "read" ]; then
    printf "${color}${message}${ESC} "
    # r: Prevent backslashes from acting as escape chars
    read -r $3
  else
    printf "\n${color}${message}${ESC}\n"
  fi
}

download() {
  # -L: Follow redirects
  # -o: Save file with specified name
  curl -Lo "$HOME/temp/$1" "$2"
}

link() {
  # -s: Make symlink
  # -f: Overwrite existing file if found
  ln -sf $1 $2
}

printColors() {
  for x in 0 1 4 5 7 8; do for i in {30..37}; do for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo "";
}

# Sync repo
g() {
  if [ -z "$1" ]; then
    print "info" "git diff --stat"
    git diff --stat
    print "read" "Commit message:" MESSAGE
    if [ -z "$MESSAGE" ]; then
      print "error" "Commit message required"
      return 1
    fi
  else
    MESSAGE="$@"
  fi

  print "info" "git fetch -p"
  if ! git fetch -p; then
    print "error" "Fetch failed"
    return 1
  fi
  print "info" "git pull"
  if ! git pull; then
    print "error" "Pull failed"
    return 1
  fi
  print "info" "git add -A"
  git add -A
  print "info" "git commit -m \"$MESSAGE\""
  git commit -m "$MESSAGE"
  print "info" "git push"
  git push
}

function gd() {
  git diff "$@" | diff-so-fancy | less -RFX
}
