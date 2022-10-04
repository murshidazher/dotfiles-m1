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

# Set dotfilesdir var if not declared.
if [ -z ${dotfilesdir+x} ]; then
  dotfilesdir="$HOME/dotfiles"
fi

botintro "Sourcing directories and files to handle."

# Declare array of directories we want to symlink.
declare -a dotfilesdirarray=(
  "$dotfilesdir/bin"
  "$dotfilesdir/.mackup"
  "$dotfilesdir/tasks"
)

# Declare array of directories we want to symlink files from.
declare -a dotfilesfilearray=(
  "$dotfilesdir/ack"
  "$dotfilesdir/android"
  "$dotfilesdir/asdf"
  "$dotfilesdir/zsh"
  "$dotfilesdir/cron"
  "$dotfilesdir/curl"
  "$dotfilesdir/editor"
  "$dotfilesdir/git"
  "$dotfilesdir/git-hooks"
  "$dotfilesdir/go"
  "$dotfilesdir/mackup"
  "$dotfilesdir/node"
  "$dotfilesdir/ruby"
  "$dotfilesdir/screen"
  "$dotfilesdir/shell"
  "$dotfilesdir/tmux"
  "$dotfilesdir/vim"
  "$dotfilesdir/wget"
  "$dotfilesdir/work"
)

success "Directories and files sourced."

# Flag files as loaded
export readonly filesloaded=true
