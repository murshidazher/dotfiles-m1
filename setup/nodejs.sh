#!/usr/bin/env bash
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./lib.sh
fi

# Load homebrew config if not already loaded.
if [ -z ${hbwloaded+x} ]; then
  source ../zsh.d/homebrew
fi

# Set defaultdotfilesdir var if not declared.
if [ -z ${defaultdotfilesdir+x} ]; then
  defaultdotfilesdir="$HOME/dotfiles"
fi

action "asdf: setting up Nodejs"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git >/dev/null 2>&1
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'

# Set the containing directory for later use
versions_dir="$defaultdotfilesdir/versions/nodejs"

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
    # if nodejs version is greater than or equal to v15.x (supported by Apple Silicon)
    local silicon_support_version=15
    if [ $(echo "${version}" | cut -d. -f1) -ge $silicon_support_version ]; then
      running "asdf: Installing ${version} for nodejs"
      asdf install nodejs ${version} >/dev/null 2>&1
      local status=$?
      if [ ${status} -ne "0" ]; then
        error "Last exit code was ${status} for 'asdf install nodejs ${version}'. Please run manually. Aborting."
        exit 1
      fi
    else
      # install the nodejs from binaries to Rosetta
      running "asdf: Installing ${version} for nodejs from binaries"
      NODEJS_CONFIGURE_OPTIONS='--with-intl=full-icu --download=all' NODEJS_CHECK_SIGNATURES="no" asdf install nodejs ref:v${version} >/dev/null 2>&1
      local status=$?
      if [ ${status} -ne "0" ]; then
        error "Last exit code was ${status} for 'asdf install nodejs ref:v${version}'. Please run manually. Aborting."
        exit 1
      else
        # symlink the version in asdf
        running "asdf: Symlink ${version} for nodejs on asdf"
        ln -s ~/.asdf/installs/nodejs/ref-v${version} ~/.asdf/installs/nodejs/${version}
        asdf reshim
      fi
    fi
  done
  # Set the latest version as global
  set_global ${version}
}

function set_global {
  local latest_version=${1}
  running "asdf nodejs: setting ${latest_version} as global"
  asdf global nodejs ${latest_version} >/dev/null 2>&1
}

action "asdf nodejs: installing versions"
install_versions
