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
	if [ -L $HOME/$1 ]; then
		# Check the symlink points to the correct location.
		if [ $(readlink $HOME/$1) = ".configs/$2" ]; then
			print $fg_bold[$COLOUR_OKAY] " > $1 is already linked."
		else
			if promptYesNo " > $1 does not point to this repository.\n   > Relink?"; then
				rm $HOME/$1
				ln -s .configs/$2 $HOME/$1
				print $fg_bold[$COLOUR_CREATE] "  > $1 link created."
			else
				print $fg_bold[$COLOUR_NO] "   > $1 skipped."
			fi
		fi
	# Check if the file already exists and prompt before action.
	elif [ -f $HOME/$1 ]; then
		if promptYesNo " > $1 already exists as a file.\n   > Remove this and link?"; then
			rm $HOME/$1
			ln -s .configs/$2 $HOME/$1
			print $fg_bold[$COLOUR_CREATE] "   > $1 removed and link created.";
		else
			print $fg_bold[$COLOUR_NO] "   > $1 skipped."
		fi
	# Link file otherwise
	else
		ln -s .configs/$2 $HOME/$1
		print $fg_bold[$COLOUR_CREATE] " > $1 link created."
	fi
}


## Entry point of script
print $fg[$COLOUR_DEFAULT] "[Symlinks] Starting."

# Check .configs links to the correct folder.
if [ -L $HOME/.configs ]; then
	DIR_CONFIGS="$(echo $(readlink -f $0) | sed -e 's#setup/.*#configs#')"
	DIR_CURRENT_CONFIGS="$(readlink $HOME/.configs)"

	if [ $DIR_CONFIGS != $DIR_CURRENT_CONFIGS ]; then
		if promptYesNo " > The current .configs symlink does not seem to point to this repository.\n   > Relink?"; then
			rm $HOME/.configs
			ln -s $DIR_CONFIGS $HOME/.configs
			print $fg_bold[$COLOUR_CREATE] "  > .configs directory link removed and recreated."
		fi
	else
		print $fg_bold[$COLOUR_OKAY] " > .configs directory is already linked."
	fi
# Link doesn't exist, so create it.
else
	ln -s $DIR_CONFIGS $HOME/.configs
	print $fg_bold[$COLOUR_CREATE] " > .configs directory link created."
fi


# Link files from repository.
linkFile ".gitconfig" "gitconfig"
linkFile ".zshrc" "shell/zshrc"
linkFile ".tmux.conf" "tmux.conf"
linkFile ".vimrc" "vimrc"

print $fg[$COLOUR_DEFAULT] "[Symlinks] Complete."
