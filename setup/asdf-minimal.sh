#!/usr/bin/env bash

# Setup agnostic asdf and install global versions
# Requires: agnostic asdf and asdf-nodejs
# Note: Use this script when you need to have a minimal setup with latest version

debug=${1:-false}
# List of components to install
PYTHON_PIPS=(httpie)
# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./setup/lib.sh
fi

# Load homebrew config if not already loaded.
if [ -z ${hbwloaded+x} ]; then
  source ./zsh.d/homebrew
fi

# Check if agnostic asdf is installed.
if hash agnostic asdf 2>/dev/null; then
  botintro "Setup agnostic asdf and global versions"

  # node
  action "asdf: setting up Node"
  agnostic asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
  # install
  action "asdf: installing global versions"

  agnostic asdf install

  # install specific nodejs version :Different
  local NODE_VERSION_12=12.22.6
  action "asdf: installing node v${NODE_VERSION_12}"
  agnostic asdf install nodejs "${NODE_VERSION_12}"
  agnostic asdf global nodejs "${NODE_VERSION_12}"
  agnostic asdf reshim nodejs

  # java
  action "asdf: setting up Java"

  agnostic asdf plugin-add java
  # adoptium openjdk 8 with JVM hotspot [difference between compilers](shorturl.at/fizN9)
  local LATEST_JAVA8_LTS_VERSION=$(asdf list-all java | grep '^adoptopenjdk-8.0.' | grep -v '\.openj9\|rc' | tail -1)
  # if you need a amazon corretto vendor latest version
  local LATEST_JAVA_CORRETTO_VERSION=$(asdf list-all java | grep '^corretto-' | tail -1)
  # install
  action "asdf: installing global versions $LATEST_JAVA8_LTS_VERSION"
  agnostic asdf install java "${LATEST_JAVA8_LTS_VERSION}"
  agnostic asdf install java "${LATEST_JAVA_CORRETTO_VERSION}"
  agnostic asdf global java "${LATEST_JAVA8_LTS_VERSION}"
  # maven
  action "asdf: setting up Maven"
  agnostic asdf plugin-add maven
  local LATEST_MAVEN_VERSION=$(asdf list-all maven | grep '^3\.' | grep -v '\-dev\|rc' | grep -v 'b\d\+' | tail -1)
  # install
  action "asdf: installing global versions of maven $LATEST_MAVEN_VERSION"
  agnostic asdf install maven "${LATEST_MAVEN_VERSION}"
  agnostic asdf global maven "${LATEST_MAVEN_VERSION}"
  # python
  agnostic asdf plugin-add python
  action "asdf: setting up Python"
  local LATEST_PYTHON2_VERSION=$(asdf list-all python | grep '^2\.' | grep -v '\-dev\|rc' | tail -1)
  local LATEST_PYTHON3_VERSION=$(asdf list-all python | grep '^3\.' | grep -v '\-dev\|rc' | grep -v 'b\d\+' | tail -1)
  # install
  action "asdf: installing global versions of python"
  agnostic asdf install python "${LATEST_PYTHON2_VERSION}"
  agnostic asdf install python "${LATEST_PYTHON3_VERSION}"
  agnostic asdf global python "${LATEST_PYTHON3_VERSION}" "${LATEST_PYTHON2_VERSION}"
  action "asdf: installing root packages"
  agnostic asdf shell python "${LATEST_PYTHON3_VERSION}"
  pip install -U pip
  pip install "${PYTHON_PIPS[@]}"

  # install specific nodejs version :Different
  local NODE_VERSION_12=12.22.6
  action "asdf: installing node v${NODE_VERSION_12}"
  agnostic asdf install nodejs "${NODE_VERSION_12}"
  agnostic asdf global nodejs "${NODE_VERSION_12}"
  agnostic asdf reshim nodejs
  # golang
  agnostic asdf plugin-add golang

  action "asdf: setting up golang"
  local LATEST_GOLANG_VERSION=$(asdf list-all golang | grep '^1\.' | grep -v '\-dev\|rc|beta' | tail -1)

  action "asdf: installing global versions of golang $LATEST_GOLANG_VERSION"
  agnostic asdf install golang "${LATEST_GOLANG_VERSION}"
  agnostic asdf global golang "${LATEST_GOLANG_VERSION}"
  go get -u $PACKAGE
  agnostic asdf reshim golang

  # fin.
else
  echo "WARNING: agnostic asdf not found."
fi
