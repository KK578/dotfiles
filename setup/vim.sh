#!/bin/zsh

## Colour setup.
autoload colors;
colors;

print $fg_bold[$COLOUR_OKAY] " > Setting up vim"

if [ ! -d $HOME/.vim/bundle/Vundle.vim ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall
fi
