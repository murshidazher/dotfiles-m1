#!/usr/bin/env zsh
debug=${1:-false}

# some bash library helpers
# @author Adam Eivy https://github.com/atomantic/dotfiles

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"\e[96m"

function ok() {
  echo -e "$COL_GREEN[ok]$COL_RESET $1"
}

function botintro() {
  echo -e "\n$COL_BLUE(っ◕‿◕)っ$COL_RESET - $1"
}
function bot() {
  echo -e "$COL_BLUE(っ◕‿◕)っ$COL_RESET - $1"
}

function actioninfo() {
  echo -e "$COL_YELLOW[action]:$COL_RESET ⇒ $1"
}

function running() {
  echo -en "$COL_YELLOW ⇒ $COL_RESET $1: "
}

function action() {
  echo -e "\n$COL_YELLOW[action]:$COL_RESET ⇒ $1"
}

function warn() {
  echo -e "$COL_YELLOW[warning]$COL_RESET $1"
}

function success() {
  echo -e "$COL_GREEN🍺  $COL_RESET $1"
}

function error() {
  echo -e "$COL_RED[error]$COL_RESET $1"
}

function cancelled() {
  echo -e "$COL_RED[cancelled]$COL_RESET $1"
}

function awesome_header() {
  echo -en "\n$COL_BLUE          ██            ██     ████ ██  ██ $COL_RESET"
  echo -en "\n$COL_BLUE         ░██           ░██    ░██░ ░░  ░██ $COL_RESET"
  echo -en "\n$COL_BLUE         ░██  ██████  ██████ ██████ ██ ░██  █████   ██████ $COL_RESET"
  echo -en "\n$COL_BLUE      ██████ ██░░░░██░░░██░ ░░░██░ ░██ ░██ ██░░░██ ██░░░░ $COL_RESET"
  echo -en "\n$COL_BLUE     ██░░░██░██   ░██  ░██    ░██  ░██ ░██░███████░░█████ $COL_RESET"
  echo -en "\n$COL_BLUE    ░██  ░██░██   ░██  ░██    ░██  ░██ ░██░██░░░░  ░░░░░██ $COL_RESET"
  echo -en "\n$COL_BLUE    ░░██████░░██████   ░░██   ░██  ░██ ███░░██████ ██████ $COL_RESET"
  echo -en "\n$COL_BLUE     ░░░░░░  ░░░░░░     ░░    ░░   ░░ ░░░  ░░░░░░ ░░░░░░ $COL_RESET"
  echo -en "\n"
  echo -en "\n"
}

function ask_for_confirmation() {
  echo -e "\e[1m$1\e[0m (y/N) "
  read -n 1
  echo -e "\n"
}

function answer_is_yes() {
  [[ "$REPLY" =~ ^(y|Y) ]] && return 0 || return 1
}

function print_result() {
  [ $1 -eq 0 ] && success "$2" || error "$2"
  [ "$3" == "true" ] && [ $1 -ne 0 ] && exit
}

function execute() {
  if $debug; then
    $1
  else
    $1 &>/dev/null
  fi
  print_result $? "${2:-$1}"
}

function require_cask() {
  running "brew cask $1"
  brew cask list "$1" >/dev/null 2>&1 | true

  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    action "brew install --cask $1 $2"
    brew install --cask "$1"

    if [[ $? != 0 ]]; then
      error "failed to install $1!"
    fi
  fi

  ok
}

function require_brew() {
  running "brew $1 $2"
  brew list "$1" >/dev/null 2>&1 | true

  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    action "brew install $1 $2"
    brew install "$1" "$2"

    if [[ $? != 0 ]]; then
      error "failed to install $1!"
    fi
  fi

  ok
}

# run architecture agnostic commands
function agnostic() {
  arch -arm64e "$@"

  if [[ $? != 0 ]]; then
    warn "failed to install using m1 $1!"
    echo "Command not supported in M1 - $@" >>~/installation_setup.log
    arch -x86_64 "$@"

    if [[ $? != 0 ]]; then
      error "failed to run $@"
    fi
  fi
  ok
}

# Check if folder is a git repo.
is_git_repository() {
  [ "$(
    git rev-parse &>/dev/null
    printf $?
  )" -eq 0 ] && return 0 || return 1
}

ask_for_sudo() {
  # Ask for the administrator password upfront
  sudo -v

  # Update existing `sudo` time stamp until this script has finished
  # https://gist.github.com/cowboy/3118588
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done &>/dev/null &
}

# Takes an array of dir locations and then handles mkdir etc.
make_directories() {
  dirsuccess=true
  local arr=("$@")

  for i in "${arr[@]}"; do
    if [ ! -d "$i" ]; then
      if $debug; then
        mkdir "$i"
      else
        mkdir -p "$i"
      fi
    else
      # test if link
      if [ -L "$i" ]; then
        error "Exists as symlink: $i"
        dirsuccess=false
      elif $debug; then
        echo -e "Directory exists: $i"
      fi
    fi
  done
}

# Creates symlinks, checks for existence etc.
process_symlinks() {
  local linksource="$1"
  local linktarget="${1/$2/$3}"
  local createlink=false

  # check if target exists
  if [ -e "$linktarget" ]; then
    ask_for_confirmation "\n'$linktarget' already exists, do you want to overwrite it?"

    if answer_is_yes; then
      if [ -L "$linktarget" ]; then
        # target is a link, unlink it.
        unlink "$linktarget"
      else
        # target is a dir or file, trash or rm it.
        # if trash is installed, prefer it, we can restore.
        if hash trash 2>/dev/null; then
          trash "$linktarget"
        else
          # rm = bye bye.
          rm -rf "$linktarget"
        fi
      fi

      createlink=true
    else
      error "Could not symlink $linksource => $linktarget"
    fi
  else
    createlink=true
  fi

  if $createlink; then
    #echo -e "$linksource $linktarget"
    execute "ln -fs $linksource $linktarget" "Symlinked: $linksource => $linktarget"
  fi
}

# Unlink symlinks, checks for existence etc.
unlink_symlinks() {
  local linksource="$1"
  local linktarget="${1/$2/$3}"

  # check if target exists
  if [ -e "$linktarget" ]; then
    if [ -L "$linktarget" ]; then
      # target is a link, unlink it.
      execute "unlink $linktarget" "Unlinked: $linktarget"
    else
      error "$linktarget is not a symlink."
    fi
  else
    error "$linktarget does not exist."
  fi
}

# Mark lib as loaded
libloaded=true
