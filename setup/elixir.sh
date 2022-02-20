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

action "asdf: setting up Elixir"

action "asdf: Setting up asdf plugins for Java, Erlang and Eixir"
asdf plugin-add java https://github.com/halcyon/asdf-java.git >/dev/null 2>&1
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git >/dev/null 2>&1
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git >/dev/null 2>&1

# Set the containing directory for later use
versions_dir="$defaultdotfilesdir/versions"

# Read given file line by line
function read_file {
  local file_path
  file_path="${1}"
  echo "read_file ${1} ${2} ${file_path}"
  while read -r line; do
    action "${line}"
  done <"${file_path}"
}

function install_versions {
  local language
  local versions_list
  language="${1}"
  versions_list=$(read_file "${versions_dir}/${language}")
  for version in ${versions_list}; do
    running "asdf: installing ${version} for ${language}"
    asdf install "${language}" "${version}" >/dev/null 2>&1
    local status=$?
    if [ ${status} -ne "0" ]; then
      error "Last exit code was ${status} for 'asdf install ${language} ${version}'. Please run manually. Aborting."
      exit 1
    fi
  done
  set_global "${language}" "${version}"
}

function set_global {
  local language
  language=${1}
  local latest_version
  latest_version=${2}
  running "asdf ${language}: setting ${latest_version} as global"
  asdf global "${language}" "${latest_version}" >/dev/null 2>&1
}

action "asdf java: installing versions"
install_versions "java"

bash -c 'source ~/.asdf/plugins/java/set-java-home.bash'
# source ~/.asdf/plugins/java/set-java-home.bash
# grep -q "source ~/.asdf/plugins/java/set-java-home.bash" ~/.zshrc || echo "source ~/.asdf/plugins/java/set-java-home.bash" >>~/.zshrc

action "asdf erlang: installing versions"
install_versions "erlang"

action "asdf elixir: installing versions"
install_versions "elixir"
