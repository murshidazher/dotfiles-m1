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

bot "Install Xcode Command Line Tools."

# Prompt user to install the XCode Command Line Tools
if ! xcode-select --print-path &>/dev/null; then
  action "Installing Xcode CLI"
  xcode-select --install &>/dev/null
  # If you get an error, run `xcode-select -r` to reset `xcode-select`.

  # Wait until the XCode Command Line Tools are installed
  until xcode-select --print-path &>/dev/null; do
    sleep 5
  done

  print_result $? 'Install Xcode Command Line Tools.'

  # Point the `xcode-select` developer directory to
  # the appropriate directory from within `Xcode.app`
  # https://github.com/alrra/dotfiles/issues/13
  sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer

  # Prompt user to agree to the terms of the Xcode license
  # https://github.com/alrra/dotfiles/issues/10
  sudo xcodebuild -license
  print_result $? 'Agree with the Xcode Command Line Tools licence.'
else
  ok "Xcode Command Line Tools already installed."
fi
