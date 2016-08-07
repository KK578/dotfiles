#!/bin/zsh

## Colour setup.
autoload colors;
colors;
COLOUR_DEFAULT="white"
COLOUR_OKAY="green"
COLOUR_PROMPT="yellow"


## Helper function to symbolically link configs in this repo to home directory.
function linkFile {
	# Check if already linked.
	if [ -L ~/$1 ]; then
		print $fg[$COLOUR_OKAY] " > $1 already linked."
	# Check if the file already exists and prompt before action.
	elif [ -f ~/$1 ]; then
		print $fg[$COLOUR_PROMPT] " > $1 already exists as a file, do you want to remove this and link?"
		select yn in "Yes" "No"; do
			case $yn in
				Yes ) print "  > Delete/Link $1"; break;;
				No ) print "  > Skipping $1"; break;;
			esac
		done
	# Link file otherwise
	else
		print $fg[$COLOUR_OKAY] " > $1 successfully linked."
	fi
}


## Entry point of script
print $fg[$COLOUR_DEFAULT] "[Symlinks] Setup."

linkFile ".gitconfig"
linkFile ".zshrc"
linkFile ".tmux.conf"
linkFile ".vimrc"

print $fg[$COLOUR_DEFAULT] "[Symlinks] Complete."
