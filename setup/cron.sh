#!/usr/bin/env zsh
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./lib.sh
  source ../zsh.d/homebrew
fi

# Set defaultdotfilesdir var if not declared.
if [ -z ${defaultdotfilesdir+x} ]; then
  defaultdotfilesdir="$HOME/dev/src/github/dotfiles-m1"
fi

# setup up the crontasks
crontab -l
crontab "$HOME/.cron"
