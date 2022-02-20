#!/usr/bin/env bash
debug=${1:-false}

# Installs Rosetta as needed on Apple Silicon Macs.
# https://raw.githubusercontent.com/rtrouton/rtrouton_scripts/main/rtrouton_scripts/install_rosetta_on_apple_silicon/install_rosetta_on_apple_silicon.sh
# https://apple.stackexchange.com/questions/407640/rosetta-2-installation-on-m1-mbp-fails

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

# Determine OS version
# Save current IFS state
OLDIFS=$IFS
IFS='.' read -r osvers_major osvers_minor osvers_dot_version <<<"$(/usr/bin/sw_vers -productVersion)"

# restore IFS to previous state
IFS=$OLDIFS

# Check to see if the Mac is reporting itself as running macOS 11
if [[ ${osvers_major} -ge 11 ]]; then

  # Check to see if the Mac needs Rosetta 2 installed by testing the processor
  processor=$(/usr/sbin/sysctl -n machdep.cpu.brand_string | grep -o "Intel")

  if [[ -n "$processor" ]]; then
    ok "$processor processor installed. No need to install Rosetta 2."
  else

    # Check for Rosetta "oahd" process. If not found,
    # perform a non-interactive install of Rosetta.
    if /usr/bin/pgrep oahd >/dev/null 2>&1; then
      ok "Rosetta 2 is already installed and running. Nothing to do."
    else
      softwareupdate --install-rosetta --agree-to-license

      if [[ $? -eq 0 ]]; then
        ok "Rosetta 2 has been successfully installed."
      else
        error "Rosetta 2 installation failed!"
      fi
    fi
  fi
else
  running "Mac is running macOS $osvers_major.$osvers_minor.$osvers_dot_version."
  ok "No need to install Rosetta 2 on this version of macOS."
fi
