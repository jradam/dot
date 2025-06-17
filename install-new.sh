# WSL (if mistake: wsl --unregister Ubuntu)
# wsl --install

# TODO: change mise globals to execs where possible
# TODO: automate font install - add to dotfiles?

# MISE
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc # Activate mise
exec bash

# TMUX 
sudo apt update 
yes | sudo apt install build-essential
yes | sudo apt install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -sf $HOME/dot/tmux/.tmux.conf $HOME/.tmux.conf
$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh

# TOOLING
mise use -g ripgrep # for nvim telescope and parrot

# GITHUB
export BROWSER="powershell.exe /C start" # this is set in bashrc later as well
mise use -g gh
gh auth login --web
gh repo clone jradam/dot
ln -sf $HOME/dot/git/.gitconfig $HOME/.gitconfig
ln -sf $HOME/dot/git/.gitignore_global $HOME/.gitignore_global
ln -sf $HOME/dot/bash/.bashrc $HOME/.bashrc

# KEYCHEF
gh repo clone jradam/keychef

# NEOVIM
mise use -g neovim@nightly
ln -sf $HOME/dot/nvim $HOME/.config/nvim
touch dot/.env # Need to add secrets here
