#!/usr/bin/env bash
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./lib.sh
fi

# List of components to install
PYTHON_PIPS=(httpie)

action "asdf: setting up python"
asdf plugin-add python >/dev/null 2>&1

# Set the containing directory for later use
versions_dir="$defaultdotfilesdir/versions"
version_2=""
version_3=""

# Read given file line by line
function read_file {
  versions_dir=${1}
  local file_path="${versions_dir}"
  while read -r line; do
    running "${line}"
  done <"${file_path}"
}

function install_versions {
  local language="${1}"
  local versions_list=$(read_file "${versions_dir}/${language}")
  for version in ${versions_list}; do
    running "asdf python: installing ${version} for ${language}"
    asdf install ${language} ${version} >/dev/null 2>&1
    if [[ ${version} == 2* ]]; then
      version_2=${version}
    fi
    if [[ ${version} == 3* ]]; then
      version_3=${version}
    fi
    local status=$?
    if [ ${status} -ne "0" ]; then
      error "Last exit code was ${status} for 'asdf install ${language} ${version}'. Please run manually. Aborting."
      exit 1
    fi
  done
  set_global ${language} ${version_3} ${version_2}
}

function set_global {
  local language=${1}
  local latest_version_3=${2}
  local latest_version_2=${3}
  running "asdf python: setting ${language} ${latest_version_3} and ${latest_version_2} as global"
  asdf global ${language} ${latest_version_3} ${latest_version_2} >/dev/null 2>&1
}

action "asdf python: installing versions"
install_versions "python"
asdf reshim python

action "asdf python: installing root packages"
asdf shell python "${version_3}"
pip install -U pip
pip install "${PYTHON_PIPS[@]}"
