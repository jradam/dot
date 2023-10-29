#!/bin/bash

source $HOME/dotfiles/bash/bin/helpers.sh
source $HOME/dotfiles/bash/bin/aliases.sh
source $HOME/dotfiles/bash/bin/defaults.sh
source $HOME/dotfiles/bash/bin/prompt.sh

# TODO pass is a nightmare, find alternative
# export NPM_TOKEN=$(pass npm)
# export OPENAI_API_KEY=$(pass openai)

# Start in tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# Make symlink files stand out more
bold='01'
orange='33'
export LS_COLORS="$LS_COLORS:ln=$bold;$orange"

# TODO ---------------------------- Old bashrc
#
# # git with message: g "add" add -A
# function g() {
#   echo -e "$c_hi $1 $c_end"
#   git "${@:2}"
# }
#
# # lazy git
# function gs() {
#   echo -e "${c_green}fetch - pull - status${c_end}"
#   git fetch -p
#   git pull
#   git status
#   # g "local" branch 
#   # g "remote" branch -r --no-merged main   
#   p "$c_blue" "--- [ COMMANDS ] ---"
#   echo -e "[${c_green}gc${c_end} ${c_blue}<branch>${c_end}]: switch to ${c_blue}<branch>${c_end}"
#   echo -e "[${c_green}lz${c_end} ${c_blue}<message>${c_end}]: add, commit ${c_blue}<message>${c_end}, push"
#   echo -e "[${c_green}gr${c_end} ${c_blue}<branch>${c_end}]: hard reset to origin/${c_blue}<branch>${c_end}"
#   echo -e "[${c_green}ghouse${c_end}]: housekeeping, optionally delete untracked local"
#   echo -e "[${c_green}gch${c_end}]: check satus of a few repos"
# }
# function gc() {
#   g "switch" switch "$@"
# }
# function lz() {
#   g "fetch" fetch -p 
#   g "pull" pull
#   g "add" add -A
#   g "commit" commit -m "$*" 
#   g "push" push
#   g "status" status
# }
# function gr() {
#   CURRENT=$(git rev-parse --abbrev-ref HEAD)
#   if [ ! "$CURRENT" ] ; then
#     echo -e "${c_red}Not in a git repo${c_end}"
#     return
#   fi
#
#   TARGET=$*
#   if [ ! "$TARGET" ] ; then
#     TARGET="main"
#   fi
#
#   if [ "$CURRENT" = "$TARGET" ] ; then
#     HIGHLIGHT=$c_blue
#   else
#     HIGHLIGHT=$c_red
#   fi
#
#   echo -e "${c_hi}reset${c_end}"
#   echo -e "${c_yellow}/// DANGER /// DANGER /// DANGER ///${c_end}"
#   echo -e "Currently on ${c_green}${CURRENT}${c_end}"
#   echo -e "Reset to ${HIGHLIGHT}origin/${TARGET}${c_end}?"
#   read -p "[y/n]: " -n 1 -r
#   echo
#
#   if [[ $REPLY =~ ^[Yy]$ ]] ; then
#     g "reset" reset --hard origin/"$TARGET"
#   else 
#     echo "aborted"
#   fi
# }
# function ghouse() {
#   g "housekeeping" gc --aggressive
#   p "$c_green" "Housekeeping complete"
#   g "branch state" branch -vv
#   echo -e "${c_yellow}/// c_red /// c_red /// c_red ///${c_end}"
#   echo -e "Delete all local branches without remote (gone)?"
#   read -p "[y/n]: " -n 1 -r
#   echo
#   if [[ $REPLY =~ ^[Yy]$ ]] ; then
#     g "delete" branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D
#   else 
#     echo "aborted"
#   fi
# }
#
# toCheck=( 
#   ~/ot/portal 
#   ~/ot/purchase 
#   ~/ot/library
#   ~/ot/admin
# )
# sed1='nothing to commit, working tree clean'
# sed2='Your branch is '
# sed3='/^[[:space:]]*$/d' # remove empty lines
# sed4='s/.*/\u&/' # capitalise
# function gch() {
#   for i in "${toCheck[@]}"
#   do
#     git -C "$i" fetch -p --quiet
#   done
#   for i in "${toCheck[@]}"
#   do
#     git -C "$i" pull --quiet
#   done
#   echo ''
#   echo -e "${c_red}----------------------------------------------${c_end}"
#   echo ''
#   for i in "${toCheck[@]}"
#   do
#     echo -e "${c_green}> ${i##*/}${c_end}"
#     git -C "$i" status | sed "s/${sed1}//" | sed "s/${sed2}//" | sed ${sed3} | sed ${sed4}
#     echo ''
#     echo -e "${c_red}----------------------------------------------${c_end}"
#     echo ''
#   done
# }
#
# function greset() {
#   git reset --hard $@ 
#   git push -f origin main
# }
#
# # for GitLab auth
# # https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/How-to-configure-GitLab-SSH-keys-for-secure-Git-connections
# # if not working try
# # https://stackoverflow.com/questions/55246165/how-to-ssh-a-git-repository-after-already-cloned-with-https
