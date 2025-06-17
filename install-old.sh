#!/bin/bash

source $HOME/dot/bash/bin/helpers.sh

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

print "info" "Github CLI"
sudo apt install gh
gh auth login --web
link $HOME/dot/git/.gitconfig $HOME/.gitconfig
link $HOME/dot/git/.gitignore_global $HOME/.gitignore_global

print "info" "tmux"
yes | sudo apt install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
link $HOME/dot/tmux/.tmux.conf $HOME/.tmux.conf
$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh
link $HOME/dot/tmux/battery.sh $HOME/.tmux/plugins/tmux/scripts/battery.sh 

print "info" "Bash"
link $HOME/dot/bash/.bashrc $HOME/.bashrc

print "info" "Neovim"
yes | sudo apt install neovim
mkdir -p $HOME/.config
link $HOME/dot/nvim $HOME/.config/nvim

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
npm install --global diff-so-fancy

print "info" "Typescript" # For typescript-tools to work globally
npm install --global typescript

print "info" "TS Node" # For running ts without having to compile first
npm install --global ts-node

print "info" "Treesitter CLI"
npm install --global tree-sitter-cli

print "info" "TypeScript styled-components support"
npm install --global @styled/typescript-styled-plugin

print "info" "WSL Open"
npm install --global wsl-open

print "title" "CONFIGURING"

print "info" "Silencing login message"
touch $HOME/.hushlogin

print "info" "Generating SSH key for Gitlab"  
yes "" | ssh-keygen -oq -t rsa -C "gitlab-ssh-key" -N "" > /dev/null

print "info" "Creating secrets file"  
touch $HOME/dot/.env

print "info" "Getting NPM token"
npm login

print "info" "Adding NPM token to secrets"
echo "export NPM_TOKEN=$(awk -F= '{print $2}' $HOME/.npmrc)" >> $HOME/dot/.env

print "title" "USER ACTIONS"

print "echo" "This needs to be copied into Gitlab (https://gitlab.com/-/profile/keys):"
cat $HOME/.ssh/id_rsa.pub

print "echo" "Add any secrets to ~/dot/.env"

print "read" "Press enter to restart" RESTART 
if [ -z $RESTART ]; then
  exec bash
fi

