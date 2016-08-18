#!/bin/zsh

## Colour setup.
autoload colors;
colors;


## Helper function prompting user for confirmation.
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


## Helper function to install a package.
function install {
	print -n $fg_bold[$COLOUR_MODIFY]
	apt-get -qq install --dry-run $1 | sed "s/^/    > /"
}


## Entry point of script
# As this script installs packages, request sudo if not root already.
if [ $EUID != 0 ]; then
	print $fg[$COLOUR_DEFAULT] "[Optional Packages]"
	sudo -E $0 $@
	exit $?
fi

# Packages file is located in configs directory.
# Can't neccessarily use .dotfiles symlink as symlinks.sh uses zsh which may not be installed.'
PACKAGES="$(echo $(readlink -f $0) | sed -e 's#setup/optional-packages.sh#configs/optional-packages.txt#')"
INSTALLED="$(dpkg --list)"

if [ -f $PACKAGES ]; then
	while IFS=\| read PACKAGE
	do
		# Install packages line by line.
		if [[ $INSTALLED =~ ii\\s*$PACKAGE\\s ]] then
			print $fg_bold[$COLOUR_OKAY] " > $PACKAGE is already installed."
		else
			if promptYesNo " > Install $PACKAGE?"; then
				install $PACKAGE
			else
				print $fg_bold[$COLOUR_NOT_OKAY] "   > $PACKAGE skipped."
			fi
		fi
	done < "$PACKAGES"
else
	print $fg_bold[$COLOUR_NOT_OKAY] " > Could not find optional package list, expected at '$PACKAGES'"
fi

print $fg[$COLOUR_DEFAULT]
