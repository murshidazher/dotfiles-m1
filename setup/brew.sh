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

# Set install flag to false
brewinstall=false

bot "Install Homebrew and all required apps."

ask_for_confirmation "\nReady to install apps? (get a coffee, this takes a while)"

# Flag install to go if user approves
if answer_is_yes || is_ci; then
  ok
  brewinstall=true
else
  cancelled "Homebrew and applications not installed."
fi

if $brewinstall; then
  # Prevent sleep.
  caffeinate &

  action "Installing Homebrew"
  # Check if brew installed, install if not.
  if ! hash brew 2>/dev/null; then
    # Note: if your /usr/local is locked down (like at Google), you can do this to place everything in ~/.homebrew
    # mkdir "$HOME/.homebrew" && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
    # then add this to your path: export PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    print_result $? 'Install Homebrew.'
  else
    success "Homebrew already installed."
  fi

  running "brew update + brew upgrade"
  # Make sure we’re using the latest Homebrew.
  brew update

  # Upgrade any already-installed formulae.
  brew upgrade

  # CORE

  running "Installing apps"
  # Install GNU core utilities (those that come with macOS are outdated).
  # Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
  brew install coreutils

  # Install some other useful utilities like `sponge`.
  brew install moreutils
  # Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
  brew install findutils
  # Install GNU `sed`, overwriting the built-in `sed`.
  brew install gnu-sed

  # Install Bash 4.
  # Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
  # running `chsh`.
  brew install bash
  brew install bash-completion@2

  # zsh
  if ! brew ls --versions zsh >/dev/null; then
    running "Installing zsh.."
    brew install zsh
  fi

  if [[ -f "/usr/local/bin/zsh" ]]; then
    if [[ ! "$(cat /etc/shells | grep /usr/local/bin/zsh)" ]]; then
      action "Allowing non-standard zsh to be set as shell"
      action /usr/local/bin/zsh | sudo tee -a /etc/shells
    fi

    # Use homebrew version if it exists
    if [[ "$(default-user-shell)" != "/usr/local/bin/zsh" ]]; then
      ok "Setting default shell to zsh (homebrew) from '$(default-user-shell)'"
      chsh -s /usr/local/bin/zsh
    fi
  else
    # Otherwise use system version
    if [[ "$(default-user-shell)" != "/bin/zsh" ]]; then
      ok "Setting default shell to zsh (system) from '$(default-user-shell)'"
      chsh -s /bin/zsh
    fi
  fi

  # zsh auto completion
  brew install zsh-completion
  brew install zsh-autosuggestions
  brew install zsh-syntax-highlighting

  # add ohmyzsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # Install `wget` with IRI support.
  brew install wget

  # Install GnuPG to enable PGP-signing commits.
  brew install gnupg

  # Install more recent versions of some native macOS tools.
  brew install perl
  brew install vim -- --with-override-system-vi
  brew install grep
  brew install nano
  brew install openssh
  brew install openssl
  brew install readline
  brew install screen

  # Key tools.
  brew install git
  brew install tmux
  brew install z

  # OTHER USEFUL UTILS
  brew install ack
  brew install advancecomp
  brew install brew-cask-completion
  brew install cloc
  brew install cmake
  brew install diff-so-fancy
  brew install fzf
  brew install gh
  brew install gibo && gibo list
  brew install git-delta
  brew install git-extras
  brew install git-lfs
  brew install git-recent
  brew install git-flow-avh
  brew install gitmoji
  brew install bfg
  brew install git-quick-stats
  brew install graphviz
  brew install grc
  brew install httpie
  brew install hub
  brew install icdiff
  brew install jq
  brew install mas
  brew install mtr
  brew install ngrep
  brew install nmap
  brew install p7zip
  brew install pidof
  brew install pigz
  brew install pv
  brew install readline
  brew install reattach-to-user-namespace
  brew install rename
  brew install roundup
  brew install spaceman-diff
  brew install spark
  brew install speedtest-cli
  brew install ssh-copy-id
  brew install terminal-notifier
  brew install the_silver_searcher
  brew install trash-cli
  brew install tree
  brew install m-cli
  brew install carlocab/personal/unrar
  brew install vbindiff
  # brew install wifi-password
  brew install zopfli
  brew install thefuck
  brew install cppunit
  brew install pidcat
  brew install gitleaks # check secret leaks

  # PHP Dependencies
  brew install bison
  brew install freetype
  brew install gd
  brew install gettext
  brew install icu4c
  brew install krb5
  brew install libedit
  brew install libiconv
  brew install libjpeg
  brew install libpng
  brew install libxml2
  brew install libzip
  brew install gmp
  brew install libsodium
  brew install imagemagick
  brew install pkg-config
  brew install re2c
  brew install zlib

  # DEV ENV
  brew install autoenv
  brew install direnv
  brew install infisical/get-cli/infisical

  # BUILD TOOLS
  brew install autoconf
  brew install automake
  brew install gcc
  brew install make

  # BACKUP
  brew install mackup

  # DEVELOPMENT
  brew install adr-tools
  brew install asdf
  brew install yarn
  brew install pyenv
  brew install pyenv-virtualenv
  brew install rbenv
  brew install ruby-build
  brew install rbenv-gemset
  brew install hugo
  brew install jsonnet

  brew install mkcert
  # brew install nss        # if you use Firefox
  mkcert -install

  brew install shellcheck   # shell script linter
  brew install shfmt        # for formatting shell scripts

  # DATABASES
  brew install mysql@5.7

  brew tap mongodb/brew
  brew install mongodb-community

  # DEVOPS
  brew install awscli
  # brew install k6

  # docker
  brew install --cask docker
  brew install kubectl

  # WEBFONT TOOLS
  running "Installing webfont tools"

  brew tap bramstein/webfonttools

  brew install sfnt2woff
  brew install sfnt2woff-zopfli
  brew install woff2

  # VPN
  brew install --cask tunnelbear

  # FONTS
  running "Installing fonts"

  brew tap murshidazher/homebrew-murshid
  brew tap homebrew/cask-fonts
  brew install svn

  brew install --cask font-domine
  brew install --cask font-fira-code
  brew install --cask font-fira-sans
  brew install --cask font-fontawesome
  brew install --cask font-inconsolata
  brew install --cask font-inter
  brew install --cask font-lato
  brew install --cask font-open-sans
  brew install --cask font-roboto
  brew install --cask font-source-code-pro
  brew install --cask font-source-sans-pro
  brew install --cask font-ubuntu
  brew install --cask font-jetbrains-mono

  running "Installing cask apps"

  # APPLICATIONS
  brew tap homebrew/cask
  brew tap homebrew/cask-versions

  # GENERAL
  brew install --cask diskwave
  brew install google-drive
  brew install --cask google-chrome
  brew install --cask grammarly
  brew install --cask iterm2
  brew install --cask slack
  brew install --cask spotify
  brew install --cask vlc
  brew install --cask appcleaner
  brew install --cask zoom
  brew install --cask microsoft-teams
  brew install --cask whatsapp
  brew install --cask openinterminal
  brew install --cask recordit

  # SECURITY
  brew install --cask authy
  brew install --cask keybase

  # DESIGN
  # brew install --cask abstract
  # brew install --cask sketch
  # brew install --cask zeplin
  # brew install --cask fontbase # font management
  # brew install --cask iconjar

  # Cask outdated but versioned
  # brew install --cask sketch@3.x # use version 63.x

  # Digital Tablet Drivers (huion)
  brew install --cask huiontablet

  # Figma Agent
  brew install --cask figma-agent

  # DEVELOPMENT
  # brew install --cask brave-browser
  brew install --cask ngrok
  brew install --cask mongodb-compass
  brew install --cask tableplus
  brew install --cask visual-studio-code
  brew install --cask intellij-idea-ce
  brew install --cask fork
  brew install --cask postman

  # DEVOPS
  brew install --cask aws-vault
  brew install terraform

  # VM
  # brew install --cask virtualbox
  # brew install --cask vagrant

  # QUICKLOOK
  brew install --cask qlcolorcode
  brew install --cask qlstephen
  brew install --cask qlmarkdown
  brew install --cask quicklook-json
  brew install --cask qlprettypatch
  brew install --cask quicklook-csv
  brew install --cask webpquicklook
  brew install --cask quicklookase
  brew install --cask qlvideo

  # PRODUCTIVITY
  brew install gmailctl
  brew install --cask krisp
  brew install --cask onyx
  brew install --cask rectangle
  brew install --cask the-unarchiver

  # DRIVERS
  running "Installing drivers"
  brew tap homebrew/cask-drivers

  # RESEARCH
  brew install --cask zotero

  # OTHERS
  brew install --cask cakebrew

  # Install Mac App Store Applications.
  # requires: brew install mas
  bot "Installing apps from the App Store..."

  ### find app ids with: mas search "app name"
  brew install mas

  ### Mas login is currently broken on mojave. See:
  ### Login manually for now.

  bot "\nNeed to log in to App Store manually to install apps with mas...."
  bot "Opening App Store. Please login."
  open "/Applications/App Store.app"

  is_not_ci && ask_for_confirmation "\nIs app store login complete. (y/n)?"

  # Flag install to go if user approves
  # Make sure you have installed these app atleast once manually using your current account
  # else app store wouldn't let you download them
  # mas search <AppName>
  if answer_is_yes && is_not_ci; then

    ## Utilites
    # mas install 1474276998 # HP Smart for Desktop
    mas install 1352778147 # Bitwarden
    mas install 1056643111 # Clocker
    mas install 692867256  # Simplenote
    mas install 1284863847 # Unsplash Wallpapers
    mas install 937984704  # Amphetamine
    mas install 1491764008 # Red 2
  else
    cancelled "App Store login not complete. Skipping installing App Store Apps"
  fi

  running "brew cleanup"
  # Remove outdated versions from the cellar.
  brew cleanup

  # turn off prevent sleep.
  killall caffeinate
fi
