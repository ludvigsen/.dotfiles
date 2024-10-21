#!/bin/bash
brew install --cask nikitabobko/tap/aerospace
brew install font-meslo-lg-nerd-font
brew install --cask wezterm
brew install nvim
brew install zoxide
brew install powerlevel10k
brew install bat
brew install fzf
brew install fd
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
brew install tmux

ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/.wezterm.lua ~/.wezterm.lua
ln -s ~/.dotfiles/aerospace/ ~/.config/aerospace
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
cd ~/.dotfiles/ || exit
git clone https://github.com/junegunn/fzf-git.sh.git
ln -s ~/.dotfiles/bat ~/.config/bat
bat cache --build

#ln -s ~/.dotfiles/.Xresources ~/.Xresources
#ln -s ~/.dotfiles/.xmonad ~/.xmonad
#ln -s ~/.dotfiles/.xmobarrc ~/.xmobarrc
#ln -s ~/.dotfiles/.Xmodmap ~/.Xmodmap
#ln -s ~/.dotfiles/.spacemacs ~/.spacemacs
#ln -s ~/.dotfiles/.SpaceVim.d ~/.SpaceVim.d
#ln -s ~/.dotfiles/lvim ~/.config/lvim
