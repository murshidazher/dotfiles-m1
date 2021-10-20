#!/usr/bin/env bash

# Setup agnostic asdf and install global versions
# Requires: agnostic asdf and asdf-nodejs
debug=${1:-false}

# List of components to install
PYTHON_PIPS=(httpie)

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./lib.sh
fi

# Load homebrew config if not already loaded.
if [ -z ${hbwloaded+x} ]; then
  source ../zsh.d/homebrew
fi

# Check if agnostic asdf is installed.
if hash agnostic asdf 2>/dev/null; then
  botintro "Setup agnostic asdf and global versions"

  # Install java, erlang and elixir
  source ./elixir.sh

  # # Install dart
  # # Note: flutter SDK includes dart, hence if you intend to install flutter comment this.
  # source ./dart.sh

  # Install flutter
  source ./flutter.sh

  # Install go
  source ./go.sh

  # Install nodejs
  source ./nodejs.sh

  # # Install php
  # source ./php.sh

  # Install python
  source ./python.sh

  # # Install ruby
  # source ./ruby.sh

  # # Install ant
  # source ./ant.sh

  # Install maven
  source ./maven.sh

  # Install gradle
  source ./gradle.sh

  # fin.
else
  echo "WARNING: agnostic asdf not found."
fi
