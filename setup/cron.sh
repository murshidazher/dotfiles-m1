#!/usr/bin/env bash
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  # shellcheck source=setup/lib.sh
  source ./setup/lib.sh
fi

# Load homebrew config if not already loaded.
if [ -z ${hbwloaded+x} ]; then
  # shellcheck source=zsh.d/homebrew
  source ./zsh.d/homebrew
fi

# Set defaultdotfilesdir var if not declared.
if [ -z ${defaultdotfilesdir+x} ]; then
  defaultdotfilesdir="$HOME/dotfiles"
fi

# setup up the crontasks
running "Checking if there are any pre-set cron tasks"
crontab -l

if is_ci; then
  running "Checking the directory structure → "
  ls -a ~
  ls -a "$HOME"
fi

action "Setting up cron tasks"
crontab "$HOME/.cron"

running "Checking if cron tasks are set"
crontab -l
