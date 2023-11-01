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

# Print and run git commands
gp() {
  print "info" "git $*"
  if ! git "$@"; then print "error" "FAILED: git $@"; return 1; fi
}

gd() {
  git diff "$@" | diff-so-fancy | less -RFX
}

# Multipurpose git function
g() {
  CURRENT=$(git symbolic-ref --short HEAD)
  UPSTREAM=$(git for-each-ref --format '%(upstream:short)' $(git symbolic-ref -q HEAD))
  echo -e "On ${PINK}${CURRENT}${ESC}, up to date with ${PINK}${UPSTREAM}${ESC}"

  if ! gp fetch -p; then return 1; fi
  if ! gp pull; then return 1; fi

  # If no arguments, show status/diff info and ask for commit message
  if [ -z "$1" ]; then
    # if no changes, return here
    if git diff-index --quiet HEAD && [ -z "$(git ls-files -o --exclude-standard)" ]; then
      print "title" "NO CHANGES"
      return 1
    fi

    NEW=$(git ls-files -o --exclude-standard)
    if [ -n "$NEW" ]; then
      echo -e "\n${GREEN}NEW ${BLUE}git ls-files -o --exclude-standard${ESC}"
      echo "$NEW" | while read -r line; do echo -e " ${GREEN}● ${ESC}$line"; done
    fi

    DIFF=$(git diff --stat --color=always)
    if [ -n "$DIFF" ]; then
      echo -e "\n${GREEN}CHANGES ${BLUE}git diff --stat${ESC}"
      echo "$DIFF"
    fi

    print "read" "\nAdd message to commit:" MESSAGE

    if [ -z "$MESSAGE" ]; then return 1; fi
  else MESSAGE="$@"; fi

  if ! gp add -A; then return 1; fi
  if ! gp commit -m "$MESSAGE"; then return 1; fi
  if ! gp push; then return 1; fi
}

# Undo last commit
gu() {
  # Remove commit locally
  gp reset HEAD^
  # Force-push the new HEAD commit
  gp push origin +HEAD
}
