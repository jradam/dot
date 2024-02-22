source $HOME/dotfiles/bash/lib/git-prompt.sh

# TODO: Tidy this, or just implement starship.rs ??

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true # staged '+', unstaged '*'
export GIT_PS1_SHOWUNTRACKEDFILES=true # '%' untracked files
export GIT_PS1_SHOWUPSTREAM="auto" # '<' behind, '>' ahead, '<>' diverged, '=' no diff
export GIT_PS1_SHOWSTASHSTATE=true # '$' something is stashed

# the `sed` removes the `=`. I don't need to know when there is no difference
P_DYNAMICGIT='$(__git_ps1 | sed s/=//)' 

# \[...\] around parts of PS1 that have length 0 helps bash get length of prompt right
c_green='\[\e[32m\]'
c_gray='\[\e[90m\]'
c_pink='\[\e[35m\]'
c_purple='\[\e[34m\]'
c_end='\[\e[0m\]'

# Check if virtualenv 
get_virtualenv() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    # Extract the name of the virtual env from its path
    echo "($(basename $VIRTUAL_ENV))"
  fi
}

P_PWD="\w"
P_BASENAME="\W"
P_TITLE="\e]0;${P_BASENAME}\a"
P_PATH="${c_purple} ${c_gray}${P_PWD}${c_end}"
P_GIT="${c_pink}${P_DYNAMICGIT}${c_end}"
P_PROMPT="\n${c_green}󰐊${c_end}"

# Run this before every command to fetch env updates without having to reset bash
update() {
  P_VIRTUALENV="${c_green} $(get_virtualenv)${c_end}"
  PS1="\n${P_TITLE}${P_PATH}${P_GIT}${P_VIRTUALENV}${P_PROMPT} "
}
PROMPT_COMMAND='update'
