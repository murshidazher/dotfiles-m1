# Package contents

Full package contents listing for [my dotfiles](https://github.com/murshidazher/dotfiles-m1).

## Core

### Bash

Bash 4 and auto-completion

- `.bashrc` — loader
- `.bash_profile` — handles bash config
- `.exports` — `$EDITOR` is vim
- `.path` — pre-configured and deduped path
- `.bash_prompt` — smart prompt
- `.aliases` — helpful aliases
- `.functions` — useful functions
- `.inputrc` — better readline config
- `z` for a better smarter `cd`

### ack

- `.ackrc` — ack config

### Curl

- `.curlrc` — curl config

### Editor

- `.editorconfig` — consistent settings for code editors
- `.prettierrc` — prettier syntax config
- `.stylelintrc` — prettier syntax config

### Git

- aliased to `g` with bash completion
- `.gitattributes`
- `.gitconfig` — aliases, settings and shorthands
- `.gitignore` — global ignore list
- `git-friendly`
- `hub` with bash completion

### iTerm2

- Solarized Dark Theme
- Solarized Dark High Contrast Theme
- Nord Theme
- Nord Light Theme

### Nano

- `.nanorc` — nano syntax config

### R Studio

- Dark Theme R Studio

### Screen

- `.screenrc` — screen config

### Shell

- `.dircolors` — better `ls` colours
- `.hushlogin` — quiet server welcomes

### Terminal

- Solarized Dark Theme (256 colours)

### tmux

- `.tmux.conf` — tmux config
- `reattach-to-user-namespace` — macOS clipboard access

### Vim

- `.vimrc` — vim config with backups, swaps and undo
- `vim-pathogen`
- `vim-colors-solarized`
- `vim-sensible` plugin
- `nerdtree` plugin
- `ctrlp.vim` plugin

### Wget

- `.wget` — wget theme

### Other

- **Xcode Command Line Tools**
- **Homebrew** — with bash completion
- **Homebrew Cask** — with bash completiton

## Installed via Homebrew

### Core utils

- `asdf` — like `nvm` but [much more...](https://asdf-vm.com/#/core-manage-versions)
- `coreutils`
- `moreutils`
- `findutils`
- `gnu-sed --with default names`
- `bash`
- `bash-completion@2`
- `zsh`
- `zsh-completion`
- `wget --with-iri`
- `gnupg`
- `perl`
- `vim --with-override-system-vi`
- `grep`
- `nano`
- `openssh`
- `screen`
- `git`
- `tmux`
- `z`

### Other useful utils

- `ack`
- `brew-cask-completion`
- `cloc`
- `diff-so-fancy`
- `fzf`
- `gibo`
- `git-extras`
- `git-lfs`
- `grc`
- `httpie`
- `hub`
- `icdiff`
- `imagemagick --with-webp`
- `jp2a`
- `jq`
- `libgit2`
- `mas`
- `mtr`
- `ngrep`
- `nmap`
- `p7zip`
- `pidof`
- `pigz`
- `pv`
- `readline`
- `reattach-to-user-namespace`
- `rename`
- `roundup`
- `spaceman-diff`
- `spark`
- `speedtest-cli`
- `ssh-copy-id`
- `terminal-notifier`
- `the_silver_searcher`
- `trash-cli`
- `tree`
- `ttygif`
- `unrar`
- `vbindiff`
- `wifi-password` - to get `wifi-password` which we have saved by `ssid` or current. `wifi-password | pbcopy` to copy it straight to clipboard.
- `youtube-dl`
- `zopfli`
- `thefuck` - corrects errors in previous console commands. `fuck` 😉

### Backup tools

- `mackup`

### Development tools

- `yarn`
- `n`
- `go`
- `homebrew/php/php56 --with-gmp`
- `pyenv`
- `pyenv-virtualenv`
- `rbenv`
- `ruby-build`
- `rbenv-gemset`
- `hugo`

### Databases

- `postgresql`
- `mongodb`
- `redis`

### DevOps tools

- `awscli` — `$AWS_PROFILE` is 'read-only'
- `heroku`
- `nginx`

### Webfont tools

`tap cask/webfonttools`

- `snt2woff`
- `sfnt2woff-zopfli`
- `woff2`

### Fonts

`tap caskroom/fonts`

- `font-fira-code`
- `font-droid-sans`
- `font-droid-sans-mono`
- `font-fontawesome`
- `font-inconsolata`
- `font-inter`
- `font-open-sans`
- `font-pt-sans`
- `font-source-code-pro`
- `font-source-sans-pro`
- `font-ubuntu`

## Applications installed via Homebrew Cask

`tap caskroom/cask`

### Security

- `bitwarden`
- `keybase`
- `gpgtools`
- `aws-vault`

### General

- `caffeine`
- `diskwave`
- `dropbox`
- `google-drive`
- `google-chrome`
- `grammarly`
- `iterm2`
- `licecap`
- `macdown`
- `oversight`
- `slack`
- `spectacle`
- `spotify`
- `vlc`
- `maccy` - read more on [here](https://github.com/p0deje/Maccy)

### Design

- `fontbase`
- `framer`
- `iconjar`
- `sketch`

### Development

- `brave-browser`
- `firefox`
- `imagealpha`
- `imageoptim`
- `ngrok`
- `vscode`
- `airtable`

### DevOps

- `aws-vault`
- `terraform`

### Quicklook plugins

- `qlcolorcode`
- `qlstephen`
- `qlmarkdown`
- `quicklook-json`
- `qlprettypatch`
- `quicklook-csv`
- `betterzipql`
- `qlimagesize`
- `webpquicklook`
- `suspicious-package`
- `quicklookase`
- `qlvideo`

### Mac App Store Applications

Installed using `mas`:

- [Contrast](https://usecontrast.com/)

## Node

- `n` to manage Node versions (latest and LTS installed)
- `.npmrc` — Node config

### Global modules

- `create-react-app`
- `caniuse-cmd`
- `doctoc`
- `git-open`
- `git-recent`
- `gulp-cli`
- `imgur-uploader-cli`
- `is-up-cli`
- `moro`
- `npm-check`
- `npm-home`
- `npm-name-cli`
- `remote-share-cli`
- `speed-test`
- `surge`
- `svgo`
- `trash-cli`
- `viewport-list-cli`
- `vtop`

## Ruby

- `rbenv` to manage Ruby versions
- `ruby-build`
- `.gemrc` — gem config

## Handy binary scripts

`/bin`

- `battery`
- `branch`
- `changelog`
- `colordump`
- `db-up`
- `git-autofixup`
- `git-big-file`
- `git-bravecheckout`
<!-- - `git-chromecheckout` -->
- `git-delete-merged-branches`
- `git-longest-message`
- `git-move-branch`
- `git-overwritten`
- `git-pr`
- `git-rank-contributers`
- `git-resolve`
- `git-sync`
- `git-thanks`
- `git-unpushed-branches`
- `git-unreleased`
- `git-where`
- `git-where-pr`
- `gitio`
- `ipsum`
- `wdate` - get the `date/time` based on search
- `pair`
- `ports`
- `rebase-authors`
- `release-tag`
- `tmux-ps`
- `tmux-session`
- `tmux-switch-session`
- `tmux-vim-select-pane`

## Mac OS

- [Mac OS X sensible defaults](../README.md#sensible-mac-os-x-defaults)
- [Quick Look plugins](#quicklook-plugins)

## Mackup

- [Mackup for backup](../README.md#mackup-for-backup)
- `.mackup.cfg` — mackup config
- `/.mackup` — individual app config for mackup
