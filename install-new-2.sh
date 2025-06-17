# SETUP
# - Install WSL with `wsl --install` (`wsl --unregister Ubuntu` to reset)
# - Run this file with `git clone https://github.com/jradam/dot && ./dot/install.sh`

# TMUX 
sudo apt update 
yes | sudo apt install build-essential tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -sf ~/dot/tmux/.tmux.conf ~/.tmux.conf
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# MISE
curl https://mise.run | sh
mkdir -p ~/.config/mise
ln -sf ~/dot/env/mise.toml ~/.config/mise/mise.toml
mise install

# GITHUB
yes | gh auth login --web
git config --global core.excludesfile ~/dot/env/.gitignore

# DIFF-SO-FANCY
curl -L https://github.com/so-fancy/diff-so-fancy/releases/latest/download/diff-so-fancy -o ~/.local/bin/diff-so-fancy
chmod +x ~/.local/bin/diff-so-fancy

# FINAL
touch dot/.env
ln -sf ~/dot/nvim ~/.config/nvim
ln -sf ~/dot/bash/.bashrc ~/.bashrc
exec bash
