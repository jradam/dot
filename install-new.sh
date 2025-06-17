# WSL (if mistake: wsl --unregister Ubuntu)
# wsl --install

# TODO: change mise globals to execs where possible
# TODO: automate font install - add to dotfiles?

# MISE
curl https://mise.run | sh
echo 'eval "$($HOME/.local/bin/mise activate bash)"' >> $HOME/.bashrc # Activate mise
source $HOME/.bashrc

# GITHUB
export BROWSER="powershell.exe /C start" # this is set in bashrc later as well
mise use -g gh
gh auth login --web
gh repo clone jradam/dot a
git config --global core.excludesfile $HOME/dot/env/.gitignore
ln -sf $HOME/dot/env/mise.toml $HOME/.config/mise/mise.toml

# TMUX 
sudo apt update 
yes | sudo apt install build-essential
yes | sudo apt install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -sf $HOME/dot/tmux/.tmux.conf $HOME/.tmux.conf
$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh

# RIPGREP 
mise use -g ripgrep # for nvim telescope and parrot

# DIFF-SO-FANCY
curl -L https://github.com/so-fancy/diff-so-fancy/releases/latest/download/diff-so-fancy -o $HOME/.local/bin/diff-so-fancy
chmod +x $HOME/.local/bin/diff-so-fancy

# KEYCHEF
gh repo clone jradam/keychef

# NEOVIM
mise use -g neovim@nightly
ln -sf $HOME/dot/nvim $HOME/.config/nvim
touch dot/.env # Need to add secrets here

# FINAL
ln -sf $HOME/dot/bash/.bashrc $HOME/.bashrc
exec bash




### Notes
https://stackoverflow.com/questions/171326/how-can-i-increase-the-key-repeat-rate-beyond-the-oss-limit
