#!/usr/bin/env bash
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

# Set defaultdotfilesdir var if not declared.
if [ -z ${defaultdotfilesdir+x} ]; then
  defaultdotfilesdir="$HOME/dotfiles"
fi

install_chrome_ext() {
  # Set default extension URL base
  URL_CHROME="https://clients2.google.com/service/update2/crx"

  # Set global extensions installation path
  PATH_CHROME_EXT="$HOME/Library/Application Support/Google/Chrome/External Extensions"

  # Break the extension input to determine the slug and extension id
  EXT_ARRAY=($(echo "$1" | tr '/' '\n'))
  EXT_SLUG="${EXT_ARRAY[0]}"
  EXT_ID="${EXT_ARRAY[1]}"

  # Setup extension path
  [ ! -d "$PATH_CHROME_EXT" ] && mkdir -p "$PATH_CHROME_EXT"

  # Install extension
  UID_ADDON_PATH="$PATH_CHROME_EXT/${EXT_ID}.json"

  # Create extension file
  echo "{" >"$UID_ADDON_PATH"
  echo "  \"external_update_url\": \"$URL_CHROME\"" >>"$UID_ADDON_PATH"
  echo "}" >>"$UID_ADDON_PATH"

  success "Installed ${EXT_SLUG}.\n"
}

export -f install_chrome_ext

if is_ci; then
  running "Checking the directory structure → "
  ls -a ~
  ls -a "$HOME"
fi

action "Installing chrome extensions"
cat "$defaultdotfilesdir"/chrome/extensions.list | xargs -I {} -P2 install_chrome_ext {}
