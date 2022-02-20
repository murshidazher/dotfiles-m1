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

# Install miniconda
action "Installing miniconda."

MINICONDA_PATH="$HOME/.miniconda"

if [ -d "$DEV_DIR" ]; then
  MINICONDA_PATH="$DEV_DIR/miniconda"
fi

# Fetch the latest installer for miniconda
if [ ! -d "$MINICONDA_PATH" ]; then
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
  chmod +x ./Miniconda3-latest-MacOSX-x86_64.sh
  ./Miniconda3-latest-MacOSX-x86_64.sh -b -p "$MINICONDA_PATH"
  rm ./Miniconda3-latest-MacOSX-x86_64.sh
fi

# Activate miniconda
export PATH="$MINICONDA_PATH/bin:$PATH"

action "Installing miniconda basic utitlity packages."

# Install the default deps
conda install numpy scipy matplotlib pip -y

success "\e[1mInstallation completed: miniconda."

# fin.
