#!/usr/bin/env bash

# Setup asdf and install global versions
# Requires: asdf and asdf-nodejs
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  # shellcheck source=setup/lib.sh
  source ./lib.sh
fi

# Load homebrew config if not already loaded.
if [ -z ${hbwloaded+x} ]; then
  # shellcheck source=zsh.d/homebrew
  source ./zsh.d/homebrew
fi

# Check if asdf is installed.
if hash asdf 2>/dev/null; then
  botintro "Setup asdf and global versions"

  # Install java, erlang and elixir
  # shellcheck source=setup/elixir.sh
  source ./elixir.sh

  # # Install dart
  # # Note: flutter SDK includes dart, hence if you intend to install flutter comment this.
  # source ./dart.sh

  # Install flutter
  # shellcheck source=setup/flutter.sh
  source ./flutter.sh

  # Install go
  # shellcheck source=setup/go.sh
  source ./go.sh

  # Install nodejs
  # shellcheck source=setup/nodejs.sh
  source ./nodejs.sh

  # # Install php
  # # shellcheck source=setup/php.sh
  # source ./php.sh

  # Install python
  # shellcheck source=setup/python.sh
  source ./python.sh

  # # Install ruby
  # # shellcheck source=setup/ruby.sh
  # source ./ruby.sh

  # # Install ant
  # # shellcheck source=setup/ant.sh
  # source ./ant.sh

  # Install maven
  # shellcheck source=setup/maven.sh
  source ./maven.sh

  # Install gradle
  # shellcheck source=setup/gradle.sh
  source ./gradle.sh

  # fin.
else
  echo "WARNING: asdf not found."
fi
