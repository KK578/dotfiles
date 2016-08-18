#!/bin/zsh

## Colour setup.
autoload colors;
colors;
export COLOUR_DEFAULT="white"
export COLOUR_OKAY="green"
export COLOUR_NOT_OKAY="red"
export COLOUR_MODIFY="cyan"
export COLOUR_PROMPT=$COLOUR_DEFAULT


## Entry point of script.
DIR_SETUP="$(echo $(readlink -f $0) | sed -e 's#install\.sh##')"


# Run other scripts in the setup process.
$DIR_SETUP/setup/packages.sh
$DIR_SETUP/setup/optional-packages.sh
$DIR_SETUP/setup/symlinks.sh

# Ensure environment is loaded.
. $DIR_SETUP/system/env

# Run other setups outside of apt-get
print $fg[$COLOUR_DEFAULT] "[Other Installations]"
$DIR_SETUP/setup/nvm.sh
$DIR_SETUP/setup/vim.sh
$DIR_SETUP/setup/oh-my-zsh.sh
print $fg[$COLOUR_DEFAULT]
