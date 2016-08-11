#!/bin/zsh

## Colour setup.
autoload colors;
colors;
COLOUR_DEFAULT="white"
COLOUR_OKAY="green"
COLOUR_CREATE="cyan"
COLOUR_PROMPT=$COLOUR_DEFAULT
COLOUR_NO="red"


## Helper function to install a package.
function install {
	print $fg_bold[$COLOUR_OKAY] " > Installing $1"
	print -n $fg[$COLOUR_CREATE]
	apt-get -qq install --dry-run $1 | sed "s/^/    > /"
}


## Entry point of script
# As this script installs packages, request sudo if not root already.
if [ $EUID != 0 ]; then
	sudo $0 $@
	exit $?
fi

print $fg[$COLOUR_DEFAULT] "[Packages] Starting."

# Packages file is located in configs directory.
# Can't neccessarily use .dotfiles symlink as symlinks.sh uses zsh which may not be installed.'
PACKAGES="$(echo $(readlink -f $0) | sed -e 's#setup/packages.sh#configs/packages.txt#')"

if [ -f $PACKAGES ]; then
	while IFS=\| read PACKAGE
	do
		# Install packages line by line.
		install $PACKAGE
	done < "$PACKAGES"
else
	print $fg_bold[$COLOUR_NO] " > Could not find package list, expected at '$PACKAGES'"
fi

print $fg[$COLOUR_DEFAULT] "[Packages] Complete."
