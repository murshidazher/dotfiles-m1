#!/usr/bin/env bash
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  # shellcheck source=setup/lib.sh
  source ./setup/lib.sh
fi

action "brew rustup: installing rustup"
brew install rustup-init # rustup

action "installing rustup"
rustup-init --profile minimal --default-toolchain stable --no-modify-path
