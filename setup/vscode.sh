#!/usr/bin/env bash

# Setup vscode and packages
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./lib.sh
fi

# Set defaultdotfilesdir var if not declared.
if [ -z ${defaultdotfilesdir+x} ]; then
  defaultdotfilesdir="$HOME/dotfiles"
fi

# add permissions
# xattr -dr com.apple.quarantine /Applications/Visual\ Studio\ Code.app

botintro "Manage VSCode Extensions"

# install vscode extensions
code --list-extensions | comm -23 - $defaultdotfilesdir/vscode/extensions.list | xargs -I {} code --uninstall-extension {} # Removes old extensions
code --list-extensions | comm -13 - $defaultdotfilesdir/vscode/extensions.list | xargs -I {} code --install-extension {}   # Adds new extensions

# if ci check if all the extensions were installed
if is_ci; then
  botintro "Checking if all VSCode Extensions were installed"
  code --list-extensions > curr-ext.list
  tr A-Z a-z < curr-ext.list | sponge curr-ext.list # convert to lowercase
  comm -23 <(sort ./curr-ext.list) <(sort $defaultdotfilesdir/vscode/extensions.list) > ext-diff.list
  cat ext-diff.list # print the difference
fi

