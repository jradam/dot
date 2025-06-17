# SETUP
# - Install WSL with `wsl --install` (`wsl --unregister Ubuntu` to reset)
# - Run this file with `git clone https://github.com/jradam/dot && ./dot/install.sh`

# TMUX
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -sf ~/dot/tmux/.tmux.conf ~/.tmux.conf
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# MISE & BASH
mkdir -p ~/.config/mise
ln -sf ~/dot/env/.mise.toml ~/.config/mise/config.toml
curl https://mise.run | sh
touch ~/dot/.env
ln -sf ~/dot/bash/.bashrc ~/.bashrc
source ~/.bashrc
mise install

# OTHER 
sudo apt update && yes | sudo apt install build-essential
ln -sf ~/dot/nvim ~/.config/nvim

# GITHUB - if too_slow error, run `wsl --shutdown` first
ln -sf ~/dot/env/.gitconfig ~/.gitconfig
yes | gh auth login --web

# NPM TOKEN
npm login
echo "export NPM_TOKEN=$(awk -F= '{print $2}' ~/.npmrc)" >> ~/dot/.env

# GITLAB SSH
yes "" | ssh-keygen -oq -t rsa -C "gitlab-ssh-key" -N "" > /dev/null
echo 'Copy key into: https://gitlab.com/-/profile/keys'
cat ~/.ssh/id_rsa.pub
read -p "Press enter to continue..."

# PROJECTS 
git clone git@gitlab.com:one-tree/portal.git ot/portal
git clone git@gitlab.com:one-tree/purchase.git ot/purchase
git clone git@gitlab.com:one-tree/admin.git ot/admin
git clone git@gitlab.com:one-tree/library.git ot/library

git clone jradam/rs

git clone jradam/keychef
git clone jradam/bufcmd
git clone jradam/tablesalt
