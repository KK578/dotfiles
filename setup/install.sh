#!/bin/zsh

## Colour setup.
export COLOUR_DEFAULT="white"
export COLOUR_OKAY="green"
export COLOUR_NOT_OKAY="red"
export COLOUR_MODIFY="cyan"
export COLOUR_PROMPT=$COLOUR_DEFAULT


## Entry point of script.
DIR_SETUP="$(echo $(readlink -f $0) | sed -e 's#/setup/.*##')"


# Run other scripts in the setup process.
$DIR_SETUP/setup/packages.sh
$DIR_SETUP/setup/symlinks.sh
