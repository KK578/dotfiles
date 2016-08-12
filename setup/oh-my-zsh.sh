#!/bin/zsh

## Colour setup.
autoload colors;
colors;

print $fg_bold[$COLOUR_OKAY] " > Setting up zsh"

# Check environment
if [ ! -n $ZSH ]; then
	print $fg_bold[$COLOUR_NOT_OKAY] "Error in environment, couldn't find \$ZSH."
	exit 1
fi

if [ ! -d $ZSH ]; then
	umask g-w,o-w

	git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH
fi
