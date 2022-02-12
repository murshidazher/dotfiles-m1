#!/usr/bin/env bash
debug=${1:-false} # default debug param.

# load help lib.
curl https://raw.githubusercontent.com/murshidazher/dotfiles-m1/main/setup/lib.sh --output ./lib.sh
source ./lib.sh

# ----
# Prep
# ----
echo -e "\n\n📦 M1 Mac Setup by [Murshid Azher](https://github.com/murshidazher/dotfiles-m1)"

defaultdotfilesdir="$HOME/dotfiles"
dotfilesdir=$(pwd)

warn "Ensure your mac system is fully up-to-date and only"
warn "run this script in terminal.app (NOT in iTerm)"
warn "run this script on ~ or ~/dev/src/github"
warn "=> CTRL+C now to abort or ENTER to continue."
is_not_ci && tput bel
is_not_ci && read -n 1

# Introduction
awesome_header

botintro "This script sets up new machines, *use with caution*. Please go read the script, it only takes a few minutes, [https://github.com/murshidazher/dotfiles-m1]."
echo -e "\nPress ENTER to continue."
is_not_ci && read -n 1

bot "To start we'll need your password.\n"

is_not_ci && tput bel

is_not_ci && ask_for_confirmation "Ready?"
if answer_is_yes || is_ci; then
  ok "Let's go."
else
  cancelled "Exit."
  exit -1
fi

# Ask for the administrator password upfront.
is_not_ci && ask_for_sudo

# Create a file to log m1 agnostic binaries
touch $HOME/installation_setup.log

# Setup macbook name
is_not_ci && ask_for_confirmation "Do you need to change your macbook name?"
if answer_is_yes && is_not_ci; then
  read -p 'Input your new macbook name: ' mbname
  sudo scutil --set ComputerName "$mbname"
  sudo scutil --set LocalHostName "$mbname"
  sudo scutil --set HostName "$mbname"
  dscacheutil -flushcache
else
  cancelled "Ok, let's continue".
fi

# Download all available macos updates.
action "Download Mac updates:\n"
sudo softwareupdate -d -a

# Install all available macos updates.
action "Installing Mac updates:\n"
sudo softwareupdate -iaR

#-------------------------------------------
# Prerequisite: Login to Github
# Generate ssh keys & add to ssh-agent
# See: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
#-------------------------------------------

running "Generating ssh keys, adding to ssh-agent... \n"
is_not_ci && read -p 'Input email for ssh key: ' useremail

running "Use default ssh file location, enter a passphrase: \n"
is_not_ci && ssh-keygen -t rsa -b 4096 -C "$useremail" # will prompt for password
is_not_ci && eval "$(ssh-agent -s)"

# Now that sshconfig is synced add key to ssh-agent and
# store passphrase in keychain
is_not_ci && ssh-add -K ~/.ssh/id_rsa
is_not_ci && success "ssh identity has been added."

# If you're using macOS Sierra 10.12.2 or later, you will need to modify your ~/.ssh/config file to automatically load keys into the ssh-agent and store passphrases in your keychain.

if [ -e ~/.ssh/config || is_ci ]; then
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
    read -p 'GitHub username: ' ghusername
    read -p 'Machine name: ' ghtitle
    read -sp 'GitHub personal token: ' ghtoken

    gh_status_code=$(curl -o /dev/null -s -w "%{http_code}\n" -u "$ghusername:$ghtoken" -d '{"title":"'$ghtitle'","key":"'"$SSH_KEY"'"}' 'https://api.github.com/user/keys')

    if (($gh_status_code - eq == 201)); then
      success "GitHub ssh key added successfully!"
      break
    else
      error "Something went wrong. Enter your credentials and try again..."
      error -n "Status code returned: "
      error $gh_status_code
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
  mkdir -p $HOME/dev/src/github
  success "Create a dev directory on root"
else
  cancelled "~/dev directory exists..."
fi

# dotfiles for vs code, emacs, gitconfig, oh my zsh, etc.
if is_not_ci; then
  running "Cloning the repo from git@github.com:murshidazher/dotfiles-m1.git to ~"
  cd ~
  gh_clone=$(git clone git@github.com:murshidazher/dotfiles-m1.git)
else
  running "Already checkout the repo in CI"
  gh_clone=""
  cd ..
fi

if (is_not_ci && !($gh_clone)); then
  error "Something went wrong. When cloning the repo..."
  error -n "Status code returned: "
  error $gh_clone
  break
else
  success "m1 dotfiles cloned successfully..."
  mv dotfiles-m1 dotfiles
  cd dotfiles
  running "Pulling new changes for dotfiles repository..."
  git pull --rebase &>/dev/null
  running "Setting up...."

  # dotfiles for vs code, emacs, gitconfig, oh my zsh, etc.
  if is_ci; then
    echo "calling setup.sh"
  else
    ./setup.sh
  fi
fi
# EOF
