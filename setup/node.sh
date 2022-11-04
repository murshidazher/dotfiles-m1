#!/usr/bin/env bash

# Setup Node install global packages
# Requires: asdf and asdf-nodejs
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

# Check if asdf is installed.
if hash asdf 2>/dev/null; then
  botintro "Installing Node global packages."

  # Create dirs and set current user as owner (prevent sudo issues)
  action "Creating Node directories"

  sudo mkdir "/usr/local/lib/node_modules"
  sudo chown -R "$(whoami)" "/usr/local/lib/node_modules"

  # Update npm for LTS.
  # note: node is installed by asdf from .tool-versions
  action "Updating npm."

  npm install npm -g

  # Install global Node packages.
  action "Installing Node global packages."

  packages=(
    appcenter-cli # for codepush
    create-react-app
    caniuse-cmd
    dependency-cruiser
    doctoc
    eslint
    git-open
    git-recent
    gzip-size-cli
    http-server
    imageoptim-cli
    is-up-cli
    javascript-typescript-langserver
    lighthouse
    neovim
    npm-check
    npm-home
    npm-name-cli
    pageres-cli
    prettier
    remote-share-cli
    serve
    source-map-explorer
    stylelint
    stylelint-config-standard
    surge
    svgo
    trash-cli
    typescript
    typescript-language-server
    viewport-list-cli
    vtop
    @vue/cli
  )

  for package in "${packages[@]}"; do
    npm install --global "$package"
  done

  # fin.
else
  echo "WARNING: asdf not found."
fi
