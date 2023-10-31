#!/bin/bash

source $HOME/dotfiles/bash/bin/helpers.sh

print "title" "PREPARING"

sudo -v

print "info" "Updating package registry"
sudo apt update 
yes | sudo add-apt-repository ppa:neovim-ppa/unstable

print "info" "Setting browser"
export BROWSER="powershell.exe /C start"

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

print "title" "CONFIGURING"

print "info" "Silencing login message"
touch $HOME/.hushlogin

print "info" "Generating SSH key for Gitlab"  
echo | ssh-keygen -oq -t rsa -C "gitlab-ssh-key"

print "info" "Creating secrets file"  
touch $HOME/dotfiles/.env

print "info" "Getting NPM token"
npm login

print "info" "Adding NPM token to secrets"
NPM_TOKEN=awk -F= '{print $2}' $HOME/.npmrc
echo "export NPM_TOKEN=$(awk -F= '{print $2}' $HOME/.npmrc)" >> $HOME/dotfiles/.env

print "title" "USER ACTIONS"

print "echo" "This needs to be copied into Gitlab (https://gitlab.com/-/profile/keys):"
cat $HOME/.ssh/id_rsa.pub

print "echo" "Add any secrets to ~/dotfiles/.env"

print "read" "Press enter to restart" RESTART 
if [ -z $RESTART ]; then
  exec bash
fi

