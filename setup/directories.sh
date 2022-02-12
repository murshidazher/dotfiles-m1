#!/usr/bin/env bash
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  # shellcheck source=setup/lib.sh
  source ./lib.sh
fi

# Load homebrew config if not already loaded.
if [ -z ${hbwloaded+x} ]; then
  # shellcheck source=zsh.d/homebrew
  source ../zsh.d/homebrew
fi

bot "Create required directories."

# Declare array of directories.
declare -a createdirarray=(
  "$HOME/Applications"
  "$HOME/work"
  "$HOME/dev/src/github"
  "$HOME/Pictures/wallpapers"
  "$HOME/.tmp"
  "$HOME/.ssh"
  "$HOME/.ssh/control"
  "$HOME/work/db_backup/mysql"
  "$HOME/work/db_backup/mongodb"
  "$HOME/work/src"
  "$HOME/work/src/github"
)

action "Creating directories"
# Send array to make_directories function.
make_directories ${createdirarray[@]}

if $dirsuccess; then
  success "Directories created."
else
  error "Errors when creating directories, please check and resolve."
  cancelled "\e[1mCannot proceed. Exit.\e[0m"
  exit -1
fi
