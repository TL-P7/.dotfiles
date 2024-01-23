#! /bin/bash

rm -rf ~/.config/nvim
ln -s ~/.dotfiles/.config/nvim ~/.config

rm -rf ~/.config/fish
ln -s ~/.dotfiles/.config/fish ~/.config

rm -rf ~/.config/i3
ln -s ~/.dotfiles/.config/i3 ~/.config

rm -rf ~/.config/kitty
ln -s ~/.dotfiles/.config/kitty ~/.config

rm -rf ~/.config/picom
ln -s ~/.dotfiles/.config/picom ~/.config

rm -rf ~/.config/chadwm
ln -s ~/.dotfiles/.config/chadwm ~/.config

rm -f ~/.gitconfig
ln -s ~/.dotfiles/.gitconfig ~

rm -f ~/.clang-format
ln -s ~/.dotfiles/.clang-format ~