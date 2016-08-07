#!/bin/zsh

## Colour setup.
autoload colors;
colors;
COLOUR_DEFAULT="white"
COLOUR_OKAY="green"
COLOUR_CREATE="cyan"
COLOUR_PROMPT=$COLOUR_DEFAULT
COLOUR_NO="red"


## Helper function prompting user for confirmation
function promptYesNo {
	print -n $fg[$COLOUR_PROMPT] "$1 [Y/N] "
	read -k 1 answer
	echo -n "\n"

	case $answer in
		y|Y )
			return 0;
			;;

		* )
			return 1;
			;;
	esac
}

## Helper function to symbolically link configs in this repo to home directory.
function linkFile {
	# Check if already linked.
	if [ -L ~/$1 ]; then
		# Check the symlink points to the correct location.
		if [ $(readlink ~/$1) = ".configs/$2" ]; then
			print $fg_bold[$COLOUR_OKAY] " > $1 is already linked."
		else
			if promptYesNo " > $1 does not point to this repository.\n   > Relink?"; then
				print $fg_bold[$COLOUR_CREATE] "  > $1 link created."
			else
				print $fg_bold[$COLOUR_NO] "   > $1 skipped."
			fi
		fi
	# Check if the file already exists and prompt before action.
	elif [ -f ~/$1 ]; then
		if promptYesNo " > $1 already exists as a file.\n   > Remove this and link?"; then
			print $fg_bold[$COLOUR_CREATE] "   > $1 removed and linked.";
		else
			print $fg_bold[$COLOUR_NO] "   > $1 skipped."
		fi
	# Link file otherwise
	else
		# ln -sv ~/.configs/$2 ~/.$1
		print $fg_bold[$COLOUR_CREATE] " > $1 link created."
	fi
}


## Entry point of script
print $fg[$COLOUR_DEFAULT] "[Symlinks] Setup."

# Check .configs links to the correct folder.
DIR_CONFIGS="$(echo $(readlink -f $0) | sed -e 's#setup/.*#configs#')"
DIR_CURRENT_CONFIGS="$(readlink ~/.configs)"

if [ $DIR_CONFIGS != $DIR_CURRENT_CONFIGS ]; then
	if promptYesNo " > The current .config symlink does not seem to point to this repository.\n   > Relink?"; then
		rm ~/.configs
		ln -s $DIR_CONFIGS ~/.configs
		print $fg_bold[$COLOUR_CREATE] "  > .configs link successfully created."
	fi
else
	print $fg_bold[$COLOUR_OKAY] " > .configs is already linked."
fi

# Link files from repository.
linkFile ".gitconfig" "gitconfig"
linkFile ".zshrc"
linkFile ".tmux.conf" "tmux.conf"
linkFile ".vimrc" "vimrc"

print $fg[$COLOUR_DEFAULT] "[Symlinks] Complete."
