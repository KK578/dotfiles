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
		if [ $(readlink $HOME/$1) = ".dotfiles/configs/$2" ]; then
			print $fg_bold[$COLOUR_OKAY] " > $1 is already linked."
		else
			if promptYesNo " > $1 does not point to this repository.\n   > Relink?"; then
				rm $HOME/$1
				ln -s .dotfiles/configs/$2 $HOME/$1
				print $fg_bold[$COLOUR_CREATE] "  > $1 link created."
			else
				print $fg_bold[$COLOUR_NO] "   > $1 skipped."
			fi
		fi
	# Check if the file already exists and prompt before action.
	elif [ -f $HOME/$1 ]; then
		if promptYesNo " > $1 already exists as a file.\n   > Remove this and link?"; then
			rm $HOME/$1
			ln -s .dotfiles/configs/$2 $HOME/$1
			print $fg_bold[$COLOUR_CREATE] "   > $1 removed and link created.";
		else
			print $fg_bold[$COLOUR_NO] "   > $1 skipped."
		fi
	# Link file otherwise
	else
		ln -s .dotfiles/configs/$2 $HOME/$1
		print $fg_bold[$COLOUR_CREATE] " > $1 link created."
	fi
}


## Entry point of script
print $fg[$COLOUR_DEFAULT] "[Symlinks] Starting."
DIR_DOTFILES="$(echo $(readlink -f $0) | sed -e 's#/setup/.*##')"

# Check .dotfiles links to this repository.
if [ -L $HOME/.dotfiles ]; then
	DIR_CURRENT_DOTFILES="$(readlink $HOME/.dotfiles)"

	if [ $DIR_DOTFILES != $DIR_CURRENT_DOTFILES ]; then
		if promptYesNo " > The current .dotfiles symlink does not seem to point to this repository.\n   > Relink?"; then
			rm $HOME/.dotfiles
			ln -s $DIR_DOTFILES $HOME/.dotfiles
			print $fg_bold[$COLOUR_CREATE] "  > .dotfiles directory link removed and recreated."
		fi
	else
		print $fg_bold[$COLOUR_OKAY] " > .dotfiles directory is already linked."
	fi
# Link doesn't exist, so create it.
else
	ln -s $DIR_DOTFILES $HOME/.dotfiles
	print $fg_bold[$COLOUR_CREATE] " > .dotfiles directory link created."
fi


# Link files from repository.
linkFile ".gitconfig" "gitconfig"
linkFile ".zshrc" "shell/zshrc"
linkFile ".tmux.conf" "tmux.conf"
linkFile ".vimrc" "vimrc"

print $fg[$COLOUR_DEFAULT] "[Symlinks] Complete."
