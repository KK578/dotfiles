#!/bin/zsh

## Colour setup.
autoload colors;
colors;

print $fg_bold[$COLOUR_OKAY] " > Installing nvm"

# Check environment
if [ ! -n $NVM_DIR ]; then
	print $fg_bold[$COLOUR_NOT_OKAY] "Error in environment, couldn't find \$NVM_DIR."
	exit 1
fi

if [ ! -d $NVM_DIR ]; then
	git clone https://github.com/creationix/nvm.git "$NVM_DIR"
	cd "$NVM_DIR"
	git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
fi
