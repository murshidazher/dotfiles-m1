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

# Set install flag to false
brewinstall=false

bot "Install Homebrew and all required apps."

ask_for_confirmation "\nReady to install apps? (get a coffee, this takes a while)"

# Flag install to go if user approves
if answer_is_yes; then
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
  # if ! hash brew 2>/dev/null; then
  #   # note: if your /usr/local is locked down (like at Google), you can do this to place everything in ~/.homebrew
  #   # mkdir "$HOME/.homebrew" && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
  #   # then add this to your path: export PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH
  #   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  #   print_result $? 'Install Homebrew.'
  # else
  #   success "Homebrew already installed."
  #   source ../zsh.d/homebrew
  # fi

  # install x86_64 supported version
  arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  running "brew update + brew upgrade"
  # Make sure we’re using the latest Homebrew.
  agnostic brew update

  # Upgrade any already-installed formulae.
  agnostic brew upgrade

  # CORE

  running "Installing apps"
  # Install GNU core utilities (those that come with macOS are outdated).
  # Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
  agnostic brew install coreutils

  # Install some other useful utilities like `sponge`.
  agnostic brew install moreutils
  # Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
  agnostic brew install findutils
  # Install GNU `sed`, overwriting the built-in `sed`.
  agnostic brew install gnu-sed

  # Install Bash 4.
  # Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
  # running `chsh`.
  agnostic brew install bash
  agnostic brew install bash-completion2

  # zsh
  if ! brew ls --versions zsh >/dev/null; then
    running "Installing zsh.."
    agnostic brew install zsh
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
  agnostic brew install zsh-completion
  agnostic brew install zsh-autosuggestions
  agnostic brew install zsh-syntax-highlighting

  # add ohmyzsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # Install `wget` with IRI support.
  agnostic brew install wget

  # Install GnuPG to enable PGP-signing commits.
  agnostic brew install gnupg

  # Install more recent versions of some native macOS tools.
  agnostic brew install perl
  agnostic brew install vim --with-override-system-vi
  agnostic brew install grep
  agnostic brew install nano
  agnostic brew install openssh
  agnostic brew install openssl
  agnostic brew install readline
  agnostic brew install screen

  # Key tools.
  agnostic brew install git
  agnostic brew install tmux
  agnostic brew install z

  # OTHER USEFUL UTILS
  agnostic brew install ack
  agnostic brew install advancecomp
  agnostic brew install brew-cask-completion
  agnostic brew install cloc
  agnostic brew install cmake
  agnostic brew install diff-so-fancy
  agnostic brew install fzf
  agnostic brew install gh
  agnostic brew install gibo && gibo -l
  agnostic brew install git-delta
  agnostic brew install git-extras
  agnostic brew install git-lfs
  agnostic brew install git-recent
  agnostic brew install git-flow-avh
  agnostic brew install gitmoji
  agnostic brew install bfg
  agnostic brew install git-quick-stats
  agnostic brew install graphviz
  agnostic brew install grc
  agnostic brew install httpie
  agnostic brew install hub
  agnostic brew install icdiff
  agnostic brew install jq
  agnostic brew install mas
  agnostic brew install mtr
  agnostic brew install ngrep
  agnostic brew install nmap
  agnostic brew install p7zip
  agnostic brew install pidof
  agnostic brew install pigz
  agnostic brew install pv
  agnostic brew install readline
  agnostic brew install reattach-to-user-namespace
  agnostic brew install rename
  agnostic brew install roundup
  agnostic brew install spaceman-diff
  agnostic brew install spark
  agnostic brew install speedtest-cli
  agnostic brew install ssh-copy-id
  agnostic brew install terminal-notifier
  agnostic brew install the_silver_searcher
  agnostic brew install trash-cli
  agnostic brew install tree
  agnostic brew install m-cli
  agnostic brew install carlocab/personal/unrar
  agnostic brew install vbindiff
  agnostic brew install wifi-password
  agnostic brew install zopfli
  agnostic brew install thefuck
  agnostic brew install cppunit
  agnostic brew install pidcat

  # PHP Dependencies
  agnostic brew install bison
  agnostic brew install freetype
  agnostic brew install gd
  agnostic brew install gettext
  agnostic brew install icu4c
  agnostic brew install krb5
  agnostic brew install libedit
  agnostic brew install libiconv
  agnostic brew install libjpeg
  agnostic brew install libpng
  agnostic brew install libxml2
  agnostic brew install libzip
  agnostic brew install pkg-config
  agnostic brew install re2c
  agnostic brew install zlib

  # DEV ENV
  agnostic brew install autoenv
  agnostic brew install direnv

  # BUILD TOOLS
  agnostic brew install autoconf
  agnostic brew install automake
  agnostic brew install gcc
  agnostic brew install make

  # BACKUP
  agnostic brew install mackup

  # DEVELOPMENT
  agnostic brew install adr-tools
  agnostic brew install asdf
  agnostic brew install yarn
  # agnostic brew install go
  # agnostic brew install homebrew/php/php56 --with-gmp
  agnostic brew install pyenv
  agnostic brew install pyenv-virtualenv
  agnostic brew install rbenv
  agnostic brew install ruby-build
  agnostic brew install rbenv-gemset
  agnostic brew install hugo
  agnostic brew install jsonnet
  agnostic brew install watchman # watch file changes

  agnostic brew install mkcert
  agnostic brew install nss # if you use Firefox
  mkcert -install

  # DATABASES
  agnostic brew install postgresql
  agnostic brew install mysql@5.7
  agnostic brew install redis

  agnostic brew tap mongodb/brew
  agnostic brew install mongodb-community

  # DEVOPS
  agnostic brew install awscli
  agnostic brew install nginx
  agnostic brew install puma/puma/puma-dev
  agnostic brew install k6

  # agnostic brew install awslogs
  agnostic brew tap lucagrulla/tap
  agnostic brew install cw # tail cloudwatch logs

  # docker
  # agnostic brew install docker
  # agnostic brew install docker-compose
  # agnostic brew install docker-machine
  # agnostic brew install xhyve
  # agnostic brew install docker-machine-driver-xhyve
  # agnostic brew install boot2docker
  agnostic brew install --cask docker
  agnostic brew install kubectl

  # WEBFONT TOOLS
  running "Installing webfont tools"

  agnostic brew tap bramstein/webfonttools

  agnostic brew install sfnt2woff
  agnostic brew install sfnt2woff-zopfli
  agnostic brew install woff2

  # FONTS
  running "Installing fonts"

  agnostic brew tap murshidazher/homebrew-murshid
  agnostic brew tap homebrew/cask-fonts
  agnostic brew install svn

  agnostic brew install --cask font-domine
  agnostic brew install --cask font-droid-sans
  agnostic brew install --cask font-droid-sans-mono
  agnostic brew install --cask font-fira-code
  agnostic brew install --cask font-fira-sans
  agnostic brew install --cask font-fontawesome
  agnostic brew install --cask font-inconsolata
  agnostic brew install --cask font-inter
  agnostic brew install --cask font-lato
  agnostic brew install --cask font-open-sans
  agnostic brew install --cask font-roboto
  agnostic brew install --cask font-source-code-pro
  agnostic brew install --cask font-source-sans-pro
  agnostic brew install --cask font-ubuntu
  agnostic brew install --cask font-sanfrancisco
  agnostic brew install --cask font-jetbrains-mono

  running "Installing cask apps"

  # APPLICATIONS
  agnostic brew tap homebrew/cask
  agnostic brew tap homebrew/cask-versions

  # GENERAL
  agnostic brew install --cask diskwave
  agnostic brew install --cask dropbox
  agnostic brew install google-drive
  # agnostic brew install --cask g-desktop-suite
  agnostic brew install --cask google-chrome
  agnostic brew install --cask grammarly
  agnostic brew install --cask iterm2
  agnostic brew install --cask slack
  # agnostic brew install --cask spectacle
  agnostic brew install --cask spotify
  agnostic brew install --cask vlc
  agnostic brew install --cask numi
  agnostic brew install --cask notion
  agnostic brew install --cask simplenote
  agnostic brew install --cask appcleaner
  # agnostic brew install --cask adobe-acrobat-reader
  agnostic brew install --cask zoom
  agnostic brew install --cask whatsapp
  agnostic brew install --cask maccy
  agnostic brew install --cask fliqlo
  agnostic brew install --cask aerial
  agnostic brew install --cask openinterminal
  agnostic brew install --cask dozer
  agnostic brew install --cask recordit
  agnostic brew install --cask keka
  agnostic brew install --cask kekaexternalhelper

  # SECURITY
  agnostic brew install --cask authy
  agnostic brew install --cask bitwarden
  agnostic brew install --cask keybase
  agnostic brew install --cask gpgtools
  agnostic brew install --cask tunnelblick
  # agnostic brew install --cask openvpn-connect

  # DESIGN
  # agnostic brew install --cask abstract
  # agnostic brew install --cask sketch
  # agnostic brew install --cask zeplin
  agnostic brew install --cask fontbase # font management
  # agnostic brew install --cask iconjar

  # Cask outdated but versioned
  # agnostic brew install --cask sketch@3.x # use version 63.x

  # DEVELOPMENT
  # agnostic brew install --cask airtable
  # agnostic brew install --cask astah-uml
  agnostic brew install --cask brave-browser
  agnostic brew install --cask firefox-developer-edition
  agnostic brew install --cask dash
  agnostic brew install --cask imagealpha
  agnostic brew install --cask imageoptim
  agnostic brew install --cask ngrok
  # agnostic brew install --cask sequel-ace # mysql management
  agnostic brew install --cask mongodb-compass
  agnostic brew install --cask robo-3t
  agnostic brew install --cask tableplus
  agnostic brew install --cask visual-studio-code
  agnostic brew install --cask intellij-idea-ce
  # agnostic brew install --cask eclipse-jee
  agnostic brew install --cask responsively
  # agnostic brew install --cask fork
  agnostic brew install --cask lepton # gist
  # agnostic brew install --cask graphiql
  # agnostic brew install --cask proxyman

  # DEVOPS
  agnostic brew install --cask aws-vault
  agnostic brew install terraform
  agnostic brew install earthly/earthly/earthly

  # VM
  # agnostic brew install --cask virtualbox
  # agnostic brew install --cask vagrant

  # QUICKLOOK
  agnostic brew install --cask qlcolorcode
  agnostic brew install --cask qlstephen
  agnostic brew install --cask qlmarkdown
  agnostic brew install --cask quicklook-json
  agnostic brew install --cask qlprettypatch
  agnostic brew install --cask quicklook-csv
  # agnostic brew install --cask betterzipql
  # agnostic brew install --cask qlimagesize
  agnostic brew install --cask webpquicklook
  # agnostic brew install --cask suspicious-package
  agnostic brew install --cask quicklookase
  agnostic brew install --cask qlvideo

  # PRODUCTIVITY
  # agnostic brew install asciinema
  agnostic brew install gmailctl
  agnostic brew install --cask krisp
  # agnostic brew install --cask the-unarchiver

  # DRIVERS
  running "Installing drivers"
  agnostic brew tap homebrew/cask-drivers
  agnostic brew install --cask logitech-options

  # RESEARCH
  # agnostic brew install --cask zotero

  # OTHERS
  agnostic brew install --cask cakebrew

  # Install Mac App Store Applications.
  # requires: agnostic brew install mas
  bot "Installing apps from the App Store..."

  ### find app ids with: mas search "app name"
  agnostic brew install mas

  ### Mas login is currently broken on mojave. See:
  ### Login manually for now.

  bot "\nNeed to log in to App Store manually to install apps with mas...."
  bot "Opening App Store. Please login."
  open "/Applications/App Store.app"

  ask_for_confirmation "\nIs app store login complete. (y/n)?"

  # Flag install to go if user approves
  # Make sure you have installed these app atleast once manually using your current account
  # else app store wouldn't let you download them
  # mas search <AppName>
  if answer_is_yes; then

    ## Utilites
    mas install 668208984  # GIPHY Capture. The GIF Maker (For recording my screen as gif)
    mas install 1351639930 # Gifski, convert videos to gifs
    # mas install 414030210  # Limechat, IRC app.
    mas install 441258766  # Magnet
    # mas install 1474276998 # HP Smart for Desktop
    mas install 490461369  # Bandwidth+
    mas install 1056643111 # Clocker
    mas install 692867256  # Simplenote
    mas install 1284863847 # Unsplash Wallpapers
    mas install 937984704 # Amphetamine
    # mas install 1470584107 # Dato

    ## Password management
    # mas install 1191757556 # Obsidian Authenticator App

  else
    cancelled "App Store login not complete. Skipping installing App Store Apps"
  fi

  running "brew cleanup"
  # Remove outdated versions from the cellar.
  agnostic brew cleanup

  # turn off prevent sleep.
  killall caffeinate
fi
