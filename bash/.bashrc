#!/bin/bash

source $HOME/dot/bash/aliases.sh
source $HOME/dot/bash/defaults.sh
source $HOME/dot/bash/git.sh
source $HOME/dot/bash/prompt.sh
source $HOME/dot/bash/runners.sh
source $HOME/dot/.env

# Link Window's browser to WSL2
export BROWSER="powershell.exe /C start"

# Start in tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# Activate mise
eval "$(~/.local/bin/mise activate bash)"
