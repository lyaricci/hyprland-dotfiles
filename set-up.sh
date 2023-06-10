#!/bin/bash

# Update system
sudo pacman -Syu

# Install zsh
sudo pacman -S zsh

# Install Noto Fonts CJK
yay -S noto-fonts-cjk

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "Oh-my-zsh installed"

# Install autocomplete
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo "Autocomplete installed"

# Install syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo "Syntax highlighting installed"

# Link zsh dotfiles
ln -sf ~/hyprland-dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/hyprland-dotfiles/zsh/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
echo "Zsh dotfiles linked"

# Install neovim
yay -S neovim
ln -sf ~/hyprland-dotfiles/.config/nvim ~/.config/
sudo pacman -S python-pip
pip install pynvim
echo "Neovim installed and files linked"

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
echo "Lazygit installed"

# Install nodejs and npm
sudo pacman -S nodejs
sudo pacman -S npm
echo "Nodejs and npm installed"

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
echo "Nvm installed"
echo "Exit terminal then run the following commands to update nodejs and npm"
echo "To update nodejs: nvm install --lts"
echo "To update npm: npm install -g npm@latest"
