#!/bin/bash

source $HOME/dot/.env
source $HOME/dot/bash/aliases.sh
source $HOME/dot/bash/defaults.sh
source $HOME/dot/bash/git.sh
source $HOME/dot/bash/runners.sh

# Link Window's browser to WSL2
export BROWSER="powershell.exe /C start"

# Start in tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# FIXME: Make symlink files stand out more
bold='01'
orange='33'
export LS_COLORS="$LS_COLORS:ln=$bold;$orange"


# Set default editor to neovim
export EDITOR=nvim

# Activate mise
eval "$(~/.local/bin/mise activate bash)"

# Activate starship
eval "$(starship init bash)"
