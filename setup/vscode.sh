#!/usr/bin/env bash

# Setup vscode and packages
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./setup/lib.sh
fi

# Load homebrew config if not already loaded.
if [ -z ${hbwloaded+x} ]; then
  source ./zsh.d/homebrew
fi

# Set defaultdotfilesdir var if not declared.
if [ -z ${defaultdotfilesdir+x} ]; then
  defaultdotfilesdir="$HOME/dev/src/github/dotfiles-m1"
fi

# add permissions
# xattr -dr com.apple.quarantine /Applications/Visual\ Studio\ Code.app

botintro "Manage VSCode Extensions"

# install vscode extensions
code --list-extensions | comm -23 - $defaultdotfilesdir/vscode/extensions.list | xargs -I {} code --uninstall-extension {} # Removes old extensions
code --list-extensions | comm -13 - $defaultdotfilesdir/vscode/extensions.list | xargs -I {} code --install-extension {}   # Adds new extensions
