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

# Set defaultdotfilesdir var if not declared.
if [ -z ${defaultdotfilesdir+x} ]; then
  defaultdotfilesdir="$HOME/dotfiles"
fi

action "asdf: setting up Gradle"
asdf plugin-add gradle
# asdf where gradle

# Set the containing directory for later use
versions_dir="$defaultdotfilesdir/versions/gradle"

# Read given file line by line
function read_file {
  local file_path
  local version_arr
  file_path="${versions_dir}"
  version_arr="${1}"

  while read -r line; do
    running "${line}"
    version_arr+=("${line}")
  done <"${file_path}"
}

# Install list of versions one by one
function install_versions {
  local versions_list
  read_file versions_list

  for version in ${versions_list}; do
    running "asdf: installing ${version} for gradle"
    asdf install gradle "${version}" >/dev/null 2>&1
    local status=$?
    if [ ${status} -ne "0" ]; then
      error "Last exit code was ${status} for 'asdf install gradle ${version}'. Please run manually. Aborting."
      exit 1
    fi
  done
  # Set the latest version as global
  set_global "${version}"
}

function set_global {
  local latest_version
  latest_version=${1}
  running "asdf gradle: setting ${latest_version} as global"
  asdf global gradle "${latest_version}" >/dev/null 2>&1
}

action "asdf gradle: installing versions"
install_versions
