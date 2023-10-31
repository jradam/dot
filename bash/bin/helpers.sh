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
  # Helper function to print git commands
  printGit() {
    print "info" "git $@"
    if ! git "$@"; then print "error" "FAILED: $@"; fi
  }

  # If no arguments, ask for commit message
  if [ -z "$1" ]; then
    printGit diff --stat
    print "read" "Commit message:" MESSAGE
    if [ -z "$MESSAGE" ]; then
      print "error" "Commit message required"
      return 1
    fi
  else MESSAGE="$@"; fi

  if ! printGit fetch -p; then return 1; fi
  if ! printGit pull --invalid-option; then return 1; fi
  if ! printGit add -A; then return 1; fi
  if ! printGit commit -m "$MESSAGE"; then return 1; fi
  if ! printGit push; then return 1; fi
}

function gd() {
  printGit diff "$@" | diff-so-fancy | less -RFX
}
