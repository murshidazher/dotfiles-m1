#!/usr/bin/env bash
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./setup/lib.sh
fi

# Load homebrew config if not already loaded.
if [ -z ${hbwloaded+x} ]; then
  source ./zsh.d/homebrew
fi

# Set defaultdotfilesdir var if not declared.
if [ -z ${defaultdotfilesdir+x} ]; then
  defaultdotfilesdir="$HOME/dev/src/github/dotfiles-m1"
fi

action "asdf: setting up Flutter"
asdf plugin-add flutter >/dev/null 2>&1

# Set the containing directory for later use
versions_dir="$defaultdotfilesdir/versions/flutter"

# Read given file line by line
function read_file {
  local file_path="${versions_dir}"
  while read -r line; do
    running "${line}"
  done <"${file_path}"
}

# Install list of versions one by one
function install_versions {
  local versions_list=$(read_file)
  for version in ${versions_list}; do
    running "asdf: installing ${version} for flutter"
    asdf install flutter ${version} >/dev/null 2>&1
    local status=$?
    if [ ${status} -ne "0" ]; then
      error "Last exit code was ${status} for 'asdf install Flutter ${version}'. Please run manually. Aborting."
      exit 1
    fi
  done
  # Set the latest version as global
  set_global ${version}
}

function set_global {
  local latest_version=${1}
  running "asdf flutter: setting ${latest_version} as global"
  asdf global flutter ${latest_version} >/dev/null 2>&1
}

action "asdf: installing versions"
install_versions

# action "asdf: there are likely manual step required"
# action "asdf: installation status"
# flutter doctor
