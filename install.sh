# SETUP
# - Install WSL with `wsl --install` (`wsl --unregister Ubuntu` to reset)
# - Run this file with `git clone https://github.com/jradam/dot && ./dot/install.sh`

# TMUX
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -sf ~/dot/tmux/.tmux.conf ~/.tmux.conf
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# MISE & BASH
mkdir -p ~/.config/mise/conf.d/
ln -sf ~/dot/env/.mise-a.toml ~/.config/mise/conf.d/.mise-a.toml
ln -sf ~/dot/env/.mise-b.toml ~/.config/mise/conf.d/.mise-b.toml
ln -sf ~/dot/env/.mise-c.toml ~/.config/mise/conf.d/.mise-c.toml
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
