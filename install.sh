# SETUP
# - Install WSL with `wsl --install` (`wsl --unregister Ubuntu` to reset)
# - Run this file with `git clone https://github.com/jradam/dot && ./dot/install.sh`

# TMUX
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -sf ~/dot/tmux/.tmux.conf ~/.tmux.conf
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# MISE & BASH
mkdir -p ~/.config/mise
ln -sf ~/dot/env/.mise.toml ~/.config/mise/.mise.toml
curl https://mise.run | sh
touch ~/dot/.env
ln -sf ~/dot/bash/.bashrc ~/.bashrc
source ~/.bashrc
mise install

# GITHUB
ln -sf ~/dot/env/.gitconfig ~/.gitconfig
yes | gh auth login --web

# FINAL
sudo apt update && yes | sudo apt install build-essential
ln -sf ~/dot/nvim ~/.config/nvim
