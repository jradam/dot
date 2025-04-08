#!/bin/bash

# TODO: add a "list all git commands and aliases" command
# TODO: don't allow commits less than two words
# TODO: combine everything into one big function on "g"

source "$HOME/dotfiles/bash/lib/colors.sh"

# Print and run git commands
gp() {
  print "info" "git $*"
  if ! git "$@"; then
    print "error" "FAILED git $@"
    return 1
  fi
}

gd() {
  git diff "$@" | diff-so-fancy | less -RFX
}

gc() {
  git branch "$@"
  git push --set-upstream origin "$@"
}

# Multipurpose git status/commit function
# TODO: "On error-reporting, up to date with" when local branch
g() {
  local CURRENT UPSTREAM NEW DIFF MESSAGE

  CURRENT=$(git symbolic-ref --short HEAD)
  UPSTREAM=$(git for-each-ref --format '%(upstream:short)' $(git symbolic-ref -q HEAD))
  echo -e "On ${PINK}${CURRENT}${ESC}, up to date with ${PINK}${UPSTREAM}${ESC}"

  # TODO: do this on one line...?
  if ! gp fetch -p; then return 1; fi
  # TODO: don't do if merging/conflicts?
  if ! gp pull; then return 1; fi

  # If no arguments, show status/diff info and ask for commit message
  if [ -z "$1" ]; then
    # if no changes, return here
    if git diff-index --quiet HEAD && [ -z "$(git ls-files -o --exclude-standard)" ] 
    then
      print "title" "NO CHANGES"
      return 1
    fi

    NEW=$(git ls-files -o --exclude-standard)
    if [ -n "$NEW" ]; then
      echo -e "\n${GREEN}NEW ${BLUE}git ls-files -o --exclude-standard${ESC}"
      echo "$NEW" | while read -r line; do
      echo -e " ${GREEN}● ${ESC}$line"
    done
    fi

    DIFF=$(git diff --stat --color=always)
    if [ -n "$DIFF" ]; then
      echo -e "\n${GREEN}CHANGES ${BLUE}git diff --stat${ESC}"
      echo "$DIFF"
    fi

    print "read" "\nAdd message to commit:" MESSAGE

    if [ -z "$MESSAGE" ]; then
      return 1
    fi
  else
    MESSAGE="$@"
    fi

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

# Multipurpose git branch function
# TODO: do a fetch first to get new branches
# TODO: alpha sorting so consistent branch order? Or can I do it by creation date (better)
# BUG: when there is a remote branch, it shows "origin" as a branch:
# BRANCHES
#  1  adding-expired-filter [local, remote]
#  2 main [local, remote]
#  3  production [local, remote]
#  4  origin [remote] <- this is a mistake
#  5  ot-portal/main [remote]

gb() {
  local SHOULD_DELETE BRANCH STRING CURRENT 
  local HAS_LOCAL=false
  local HAS_REMOTE=false

  declare -A BRANCHES
  declare -a NUMBERED

  local i=0

  for branch in $(git branch --format "%(refname:short)"); do
    BRANCHES[$branch]="local"
    NUMBERED[$i]=$branch
    i=$((i + 1))
  done

  for branch in $(git branch -r --format "%(refname:short)" | sed 's/origin\///'); do
    if [[ "$branch" != "HEAD" ]]; then
      if [ "${BRANCHES[$branch]}" == "local" ]; then
        BRANCHES[$branch]="local, remote"
      else
        BRANCHES[$branch]="remote"
        NUMBERED[$i]=$branch
        i=$((i + 1))
      fi
    fi
  done

  CURRENT=$(git branch --show-current)
  echo -e "\n${GREEN}BRANCHES${ESC}"
  for i in "${!NUMBERED[@]}"; do
    local PREFIX=" "
    if [ "$CURRENT" == "${NUMBERED[$i]}" ]; then
      PREFIX="${GREEN}${ESC}"
    fi
    echo -e " $((i + 1)) $PREFIX${PINK}${NUMBERED[$i]}${ESC} [${BRANCHES[${NUMBERED[$i]}]}]"
  done

  print "read" "\nType number to checkout, type name to delete:" USER_INPUT
  if [ -z "$USER_INPUT" ]; then return 1; fi

  # If the input is a number, validate and then checkout the branch
  if [[ "$USER_INPUT" =~ ^[0-9]+$ ]]; then
    if [ "$USER_INPUT" -ge 1 ] && [ "$USER_INPUT" -le "${#NUMBERED[@]}" ]; then
      # TODO: ensure we are printing out the commands like this everywhere 
      gp checkout "${NUMBERED[$USER_INPUT - 1]}"
      return 0
    else
      print "error" "Invalid number. No such branch."
      return 1
    fi
  fi

  BRANCH="$USER_INPUT"

  if git show-ref --verify --quiet refs/heads/"$BRANCH"; then
    HAS_LOCAL=true
  fi

  if [ -n "$(git ls-remote --heads origin "$BRANCH" 2>/dev/null)" ]; then
    HAS_REMOTE=true
  fi

  if [ "$HAS_LOCAL" = false ] && [ "$HAS_REMOTE" = false ]; then
    print "error" "No local or remote branch named $BRANCH"
    return 1
  fi

  print "read" "Are you sure you want to delete: ${PINK}$BRANCH${ESC}" SHOULD_DELETE 
  if [ ! -z "$SHOULD_DELETE" ]; then return 1; fi

  if [ "$HAS_LOCAL" = true ]; then git branch -d "$BRANCH"; fi
  if [ "$HAS_REMOTE" = true ]; then git push origin -d "$BRANCH"; fi
}

_gb_completion() {
  local cur opts
  cur="${COMP_WORDS[COMP_CWORD]}"
  opts=$(git branch --format "%(refname:short)")
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}
complete -F _gb_completion gb


# TODO: add completion to gd() as well

# TODO:
# git branch helpers
# git push --set-upstream origin helpers
