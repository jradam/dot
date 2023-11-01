#!/bin/bash

source "$HOME/dotfiles/bash/lib/colors.sh"

# Print and run git commands
gp() {
  print "info" "git $*"
  if ! git "$@"; then
    print "error" "FAILED: git $@"
    return 1
  fi
}

gd() {
  git diff "$@" | diff-so-fancy | less -RFX
}

# Multipurpose git status/commit function
g() {
  local CURRENT UPSTREAM NEW DIFF MESSAGE

  CURRENT=$(git symbolic-ref --short HEAD)
  UPSTREAM=$(git for-each-ref --format '%(upstream:short)' $(git symbolic-ref -q HEAD))
  echo -e "On ${PINK}${CURRENT}${ESC}, up to date with ${PINK}${UPSTREAM}${ESC}"

  # TODO do this on one line...?
  if ! gp fetch -p; then return 1; fi
  # TODO don't do if merging/conflicts?
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

  # If the input is a number, checkout the branch and return
  if [[ "$USER_INPUT" =~ ^[0-9]+$ ]]; then
    git checkout "${NUMBERED[$USER_INPUT - 1]}"
    return 0
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

