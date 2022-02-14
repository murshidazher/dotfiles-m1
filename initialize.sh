#!/usr/bin/env bash

# load help lib.
if [[ -f "./setup/lib.sh" ]]; then
  # shellcheck source=setup/lib.sh
  source "./setup/lib.sh"
else
  curl https://raw.githubusercontent.com/murshidazher/dotfiles-m1/main/setup/lib.sh --output lib.sh
  source "./lib.sh" 2>/dev/null
fi

# ----
# Prep
# ----
echo -e "\n\n📦 M1 Mac Setup by [Murshid Azher](https://github.com/murshidazher/dotfiles-m1)"
warn "Ensure your mac system is fully up-to-date and only"
warn "run this script in terminal.app (NOT in iTerm)"
warn "run this script on ~"
warn "=> CTRL+C now to abort or ENTER to continue."
is_not_ci && tput bel
is_not_ci && read -r -n 1

# Introduction
awesome_header

botintro "This script sets up new machines, *use with caution*. Please go read the script, it only takes a few minutes, [https://github.com/murshidazher/dotfiles-m1]."
echo -e "\nPress ENTER to continue."
is_not_ci && read -r -n 1

bot "To start we'll need your password."

is_not_ci && tput bel

is_not_ci && ask_for_confirmation "Ready?"
if answer_is_yes || is_ci; then
  ok "Let's go."
else
  cancelled "Exit."
  exit 1
fi

# Ask for the administrator password upfront.
is_not_ci && ask_for_sudo

# Create a file to log m1 agnostic binaries
touch "$HOME/installation_setup.log"

# Setup macbook name
is_not_ci && ask_for_confirmation "Do you need to change your macbook name?"
if answer_is_yes && is_not_ci; then
  read -r -p 'Input your new macbook name: ' mbname
  sudo scutil --set ComputerName "$mbname"
  sudo scutil --set LocalHostName "$mbname"
  sudo scutil --set HostName "$mbname"
  dscacheutil -flushcache
else
  cancelled "Ok, let's continue".
fi

# Download all available macos updates.
action "Download Mac updates:"
sudo softwareupdate -d -a

# Install all available macos updates.
action "Installing Mac updates:"
sudo softwareupdate -iaR

#-------------------------------------------
# Prerequisite: Login to Github
# Generate ssh keys & add to ssh-agent
# See: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
#-------------------------------------------

running "Generating ssh keys, adding to ssh-agent... "
is_not_ci && read -r -p 'Input email for ssh key: ' useremail

running "Use default ssh file location, enter a passphrase: "
is_not_ci && ssh-keygen -t rsa -b 4096 -C "$useremail" # will prompt for password
is_not_ci && eval "$(ssh-agent -s)"

# Now that sshconfig is synced add key to ssh-agent and
# store passphrase in keychain
is_not_ci && ssh-add -K ~/.ssh/id_rsa
is_not_ci && success "ssh identity has been added."

# If you're using macOS Sierra 10.12.2 or later, you will need to modify your ~/.ssh/config file to automatically load keys into the ssh-agent and store passphrases in your keychain.

if [[ -e ~/.ssh/config ]] || is_ci; then
  cancelled "ssh config already exists. Skipping adding osx specific settings... "
else
  success "Writing osx specific settings to ssh config... "
  cat <<EOT >>~/.ssh/config
	Host *
		AddKeysToAgent yes
		UseKeychain yes
		IdentityFile ~/.ssh/id_rsa
EOT
fi

#-------------------------------------------
# Add ssh-key to GitHub via api
#-------------------------------------------

if is_not_ci; then
  action "Adding ssh-key to GitHub (via api)..."
  warn "Important! For this step, use a github personal token with the admin:public_key permission."
  actioninfo "If you don't have one, create it here: https://github.com/settings/tokens/new"

  retries=3
  SSH_KEY=$(cat ~/.ssh/id_rsa.pub)

  for ((i = 0; i < retries; i++)); do
    read -r -p 'GitHub username: ' ghusername
    read -r -p 'Machine name: ' ghtitle
    read -r -sp 'GitHub personal token: ' ghtoken

    gh_status_code=$(curl -o /dev/null -s -w "%{http_code}" -u "$ghusername:$ghtoken" -d '{"title":"'"$ghtitle"'","key":"'"$SSH_KEY"'"}' 'https://api.github.com/user/keys')

    if [[ $gh_status_code -eq 201 ]]; then
      success "GitHub ssh key added successfully!"
      break
    else
      error "Something went wrong. Enter your credentials and try again..."
      error -n "Status code returned: "
      error "$gh_status_code"
    fi
  done

  [[ $retries -eq i ]] && botintro "Adding ssh-key to GitHub failed! Try again later."
fi

#-------------------------------------------
# Install dotfiles repo, run link script
#-------------------------------------------

# Source directories and files to handle.
# source ./setup/files.sh

if [ ! -d "$HOME/dev/src/github" ]; then
  mkdir -p "$HOME/dev/src/github"
  success "Create a dev directory on root"
else
  cancelled "$HOME/dev directory exists..."
fi

# dotfiles for vs code, emacs, gitconfig, oh my zsh, etc.
if is_not_ci; then
  cd ~ || exit
  running "Cloning the repo from git@github.com:murshidazher/dotfiles-m1.git to ~"
  gh_clone=$(git clone git@github.com:murshidazher/dotfiles-m1.git dotfiles)
else
  cd ~ || exit
  if [ -d "dotfiles" ]; then
    running "Already checkout the repo in CI"
    gh_clone=""
  else
    running "Cloning the repo from https://github.com/murshidazher/dotfiles-m1.git"
    gh_clone=$(git clone https://github.com/murshidazher/dotfiles-m1.git dotfiles)
  fi
fi

if (! $gh_clone); then
  error "Something went wrong. When cloning the repo..."
  error -n "Status code returned: "
  error "$gh_clone"
else
  success "m1 dotfiles cloned successfully..."
  running "Checking the directory structure → "
  ls
  cd dotfiles || exit
  running "Pulling new changes for dotfiles repository..."
  git pull --rebase &>/dev/null
  running "Setting up...."

  # dotfiles for vs code, emacs, gitconfig, oh my zsh, etc.
  if is_ci; then
    if [[ -z "${RUN_SETUP}" ]]; then
      running "Skipping calling setup.sh in CI"
    else
      running "Running setup.sh in CI"
      ./setup.sh
    fi

    # # rename the dotfiles back for repo cleanup
    # running "Cleanup for post checkout submodules"
    # cd ..
    # running "Before repo name change → "
    # ls
    # mv dotfiles dotfiles-m1
    # running "After repo name change → "
    # ls
    # cd dotfiles-m1 || exit
  else
    ./setup.sh
  fi
fi
# EOF
