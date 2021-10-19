#!/usr/bin/env bash

# Setup asdf and install global versions
# Requires: asdf and asdf-nodejs
debug=${1:-false}

# List of components to install
PYTHON_PIPS=(httpie)

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./lib.sh
  source ../zsh.d/homebrew
fi

# Check if asdf is installed.
if hash asdf 2>/dev/null; then
  botintro "Setup asdf and global versions"

  # Install java, erlang and elixir
  source ./elixir.sh

  # Install dart
  source ./dart.sh

  # Install flutter
  source ./flutter.sh

  # Install go
  source ./go.sh

  # Install nodejs
  source ./nodejs.sh

  # Install php
  source ./php.sh

  # Install python
  source ./python.sh

  # Install ruby
  source ./ruby.sh

  # Install ant
  source ./ant.sh

  # Install maven
  source ./maven.sh

  # Install gradle
  source ./gradle.sh

  # fin.
else
  echo "WARNING: asdf not found."
fi
