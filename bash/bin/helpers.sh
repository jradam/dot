#!/bin/bash

source $HOME/dotfiles/bash/lib/colors.sh

print() {
  local type=$1
  local message=$2
  local color

  case $type in
    "echo") color=$GRAY ;;
    "error") color=$RED ;;
    "info") color=$BLUE ;;
    "read") color=$ORANGE ;;
    "title") color=$GREEN ;;
    *) color=$GRAY ;;
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

# Sync dotfiles repo
sync() {
  print "read" "Commit message: " MESSAGE
  
  # -C: Run command in specified directory
  # -p: Prune remote branches 
  if git -C $HOME/dotfiles fetch -p; then
    if git -C $HOME/dotfiles pull; then
      # -A: Add all changes
      git -C $HOME/dotfiles add -A
      # -m: Commit with provided message 
      git -C $HOME/dotfiles commit -m "$MESSAGE"
      git -C $HOME/dotfiles push
    else
      echo "Pull failed. Aborting."
      exit 1
    fi
  else
    echo "Fetch failed. Aborting."
    exit 1
  fi
}

# Print all colors
function printColors() {
  for x in 0 1 4 5 7 8; do for i in {30..37}; do for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo "";
}

