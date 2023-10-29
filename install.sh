#!/bin/bash

source $HOME/dotfiles/bash/bin/helpers.sh

print "title" "PREPARING"

sudo -v

print "info" "Updating package registry"
sudo apt update 
yes | sudo add-apt-repository ppa:neovim-ppa/unstable

print "title" "INSTALLING"

print "info" "Install common dependencies"
yes | sudo apt install build-essential
sudo apt install ripgrep # for nvim telescope 
sudo apt install unzip # for nvim mason
# sudo apt install xsel # is default clipboard still broken?
# sudo apt install python3-pip # actually needed for treesitter?

print "info" "Github CLI"
sudo apt install gh
gh auth login --web
link $HOME/dotfiles/git/.gitconfig $HOME/.gitconfig

print "info" "tmux"
yes | sudo apt install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
link $HOME/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf
$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh
link $HOME/dotfiles/tmux/bin/battery.sh $HOME/.tmux/plugins/tmux/scripts/battery.sh

print "info" "Bash"
link $HOME/dotfiles/bash/.bashrc $HOME/.bashrc

print "info" "Neovim"
yes | sudo apt install neovim
mkdir -p $HOME/.config
link $HOME/dotfiles/nvim $HOME/.config/nvim

print "info" "NVM"
git clone https://github.com/nvm-sh/nvm.git .nvm
git -C .nvm fetch --tags
LATEST_TAG=$(git -C .nvm describe --tags `git -C .nvm rev-list --tags --max-count=1`)
git -C .nvm checkout $LATEST_TAG
source $HOME/.nvm/nvm.sh

print "info" "Node"
nvm install --lts
nvm alias default node

print "info" "Yarn"
npm install --global yarn

print "info" "Diff so fancy"
npm i -g diff-so-fancy

print "title" "CLEANUP"

print "info" "Silencing login message"
touch $HOME/.hushlogin

print "title" "COMPLETE"

print "read" "Press enter to restart" restart
if [ -z $restart ]; then
  exec bash
fi

