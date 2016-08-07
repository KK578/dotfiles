#!/bin/zsh

## Colour setup.
autoload colors;
colors;
COLOUR_DEFAULT="white"
COLOUR_OKAY="green"
COLOUR_CREATE="cyan"
COLOUR_PROMPT="yellow"


## Helper function to symbolically link configs in this repo to home directory.
function linkFile {
	# Check if already linked.
	if [ -L ~/.$1 ]; then
		print $fg[$COLOUR_OKAY] " > $1 is already linked."
	# Check if the file already exists and prompt before action.
	elif [ -f ~/.$1 ]; then
		print -n $fg[$COLOUR_PROMPT] " > $1 already exists as a file, do you want to remove this and link? [Y/N] "
		read -k 1 answer
		echo -n "\n"
		case $answer in
			y|Y )
				print "   > Delete/Link $1";
				;;

			* )
				print "   > Skipping $1";
				;;
		esac
	# Link file otherwise
	else
		# ln -sv ~/.configs/$2 ~/.$1
		print $fg_bold[$COLOUR_CREATE] " > $1 link created."
	fi
}


## Entry point of script
print $fg[$COLOUR_DEFAULT] "[Symlinks] Setup."

# Check .configs links to the correct folder.
DIR_CONFIGS="$(echo $(readlink -f '$0') | sed -e 's#setup/.*#configs#')"
DIR_CURRENT_CONFIGS="$(readlink ~/.configs)"

if [ DIR_CONFIGS != DIR_CURRENT_CONFIGS ]; then
	echo "They not the same Jim."
fi

# Link files from repository.
linkFile "gitconfig"
linkFile "zshrc"
linkFile "tmux.conf"
linkFile "vimrc"

print $fg[$COLOUR_DEFAULT] "[Symlinks] Complete."
