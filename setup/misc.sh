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
  dotfilesdir="$HOME/${PWD##*/}"
fi

action "Setting up .nanorc"
# Install better nanorc config.
# https://github.com/scopatz/nanorc
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

action "Setting chmod for ~/.ssh"
chmod 700 "$HOME/.ssh"
print_result $? "Set chmod 700 on ~/.ssh"

action "Setting chmod for ~/.gnupg"
mkdir "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"

# Install the Solarized Dark theme for Terminal
action "Installing Solarized Dark for Terminal"
open "${dotfilesdir}/terminal/Solarized Dark xterm-256color.terminal"

# Install the Solarized Dark High Contrast theme for iTerm2
action "Installing Solarized Dark High Contrast for iTerm2"
open "${dotfilesdir}/iterm2/Solarized Dark High Contrast.itermcolors"

success "Final touches in place."
