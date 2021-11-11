<img src="https://raw.githubusercontent.com/murshidazher/dotfiles-m1/main/docs/images/logo.jpg" width="90px">

# [dotfiles-m1](https://github.com/murshidazher/dotfiles-m1)

> My personal installation script to automate any new macOS system setup so I don't need to feel poor.

- A dogmatic script to set up my mac. Built for Mac OS X :fire: :fire:

<img src="https://raw.githubusercontent.com/murshidazher/dotfiles-m1/main/docs/images/terminal.png" width="240px">

<img src="https://raw.githubusercontent.com/murshidazher/dotfiles-m1/main/docs/images/vscode.png" width="240px">

## Table of Contents

- [dotfiles-m1](#dotfiles-m1)
  - [Table of Contents](#table-of-contents)
  - [Installing / Getting started](#installing--getting-started)
    - [Setup](#setup)
      - [GPG key with Keybase.io](#gpg-key-with-keybaseio)
    - [Homebrew](#homebrew)
    - [Python](#python)
    - [ASDF Ruby](#asdf-ruby)
    - [Projects](#projects)
    - [Ant](#ant)
    - [Run React Native App](#run-react-native-app)
      - [ios setup](#ios-setup)
      - [Clean pod](#clean-pod)
    - [Compinit error](#compinit-error)
  - [Vscode error](#vscode-error)
  - [QuickLook Plugin](#quicklook-plugin)
  - [Vscode Permission error when installing extensions](#vscode-permission-error-when-installing-extensions)
  - [TODO](#todo)
  - [License](#license)

## Installing / Getting started

> ⚠️ Scripts in this project performs automated tasks. Review the code first and use at your own risk! ⚠️

### Setup

To setup simply open the terminal, then:

```sh
> bash -c "`curl -L https://git.io/dotfiles-m1`"
```

#### GPG key with Keybase.io

- Follow this gist to [setup gpgkey with keybase.io](https://github.com/pstadler/keybase-gpg-github).

### Homebrew

- `/usr/local` on macOS intel
- `/opt/homebrew` on macOS ARM
- `/home/linuxbrew` on Linux

```sh
if [[ "$(uname -m)" == "arm64" ]]; then
  export PATH="/opt/homebrew/bin:${PATH}"
fi
```

### Python

```sh
> sudo ln -s -f $(which python3) $(which python)
> which python
/Users/murshidazher/.asdf/shims/python
```

Open rosetta terminal,

```sh
> NODEJS_CONFIGURE_OPTIONS='--with-intl=full-icu --download=all' NODEJS_CHECK_SIGNATURES="no" asdf install nodejs ref:v12.16.1
> cd ~/.asdf/installs/nodejs
> ln -s ref-v12.16.1 12.16.1
> asdf reshim
> asdf global nodejs 12.16.1
```

### ASDF Ruby 

```sh
> asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
> asdf install ruby 2.7.4
> asdf global ruby 2.7.4
> gem install bundler:2.2.19 -n /usr/local/bin
> gem install --user-install ffi -- --enable-libffi-alloc
```

### Projects

```sh
> npm rebuild node-sass
```

### Ant

```sh
> asdf plugin add ant
> asdf list-all ant
> asdf install ant latest
> asdf global ant latest
> ant -version
```

### Run React Native App

```sh
# install and link (to install native dependencies)
> asdf local nodejs 14.18.1
> npm i
> react-native link

# create a .dev.env file inside
> npm run setupEnv
> npm run start # start the metro bundler
> npm run android:qa
```

#### ios setup

```sh
> cd react-native-owner-app/ios
> pod install
```

#### Clean pod

```sh
> pod cache clean --all # will clean all pods
> rm -rf ~/Library/Caches/CocoaPods
> rm -rf Pods
> rm -rf ~/Library/Developer/Xcode/DerivedData/*
> pod deintegrate
> pod setup
> pod install
```

### Compinit error

- Refer to this [stackoverflow](https://stackoverflow.com/questions/65747286/zsh-problem-compinit503-no-such-file-or-directory-usr-local-share-zsh-site)

```txt
compinit:503: no such file or directory: /usr/local/share/zsh/site-functions/_asdf
compinit:503: no such file or directory: /usr/local/share/zsh/site-functions/_brew
compinit:shift:505: shift count must be <= $#
```

```sh
> ln -fsv /opt/homebrew/completions/zsh/_brew /usr/local/share/zsh/site-functions/_brew
> ln -fsv /opt/homebrew/opt/asdf/etc/bash_completion.d/asdf.bash /opt/homebrew/completions/zsh/_asdf
> ln -fsv /opt/homebrew/completions/zsh/_asdf /usr/local/share/zsh/site-functions/_asdf
```

## Vscode error

When attempting to launch vscode using the `code .` command you might get the following error,

```sh
/usr/local/bin/code: line 10: ./MacOS/Electron: No such file or directory
```

This most likely occurs because of error in python path, symlink the python path manually,

```sh
> sudo ln -s -f $(which python2) $(which python)
```

## QuickLook Plugin

> “QLStephen.qlgenerator” can’t be opened because Apple cannot check it for malicious software.

Issue the following command to alleviate the issue, effectively marking the QLGenerator as safe:

```sh
> sudo xattr -cr ~/Library/QuickLook/*.qlgenerator
# reset quicklookd
> qlmanage -r
> qlmanage -r cache
```

## Vscode Permission error when installing extensions

Permission error encountered when updating vscode extensions,

```sh
> sudo chown -R $(whoami):staff $HOME/Library/Application\ Support/CodeCachedExtensionVSIXs
> sudo chown -R $(whoami):staff $HOME/.vscode/extensions/*
```

## TODO

- [ ] Add common configurations to docs directory
- [ ] https://firebase.google.com/docs/app-distribution/ios/distribute-fastlane
- [ ] change zsh_prompt color profile
- [ ] setting up nodejs before v16 in m1. Build them from binaries. Refer [this](https://github.com/asdf-vm/asdf-nodejs/issues/78#issuecomment-842771319)

## License

[MIT](https://github.com/murshidazher/dotfiles-m1/blob/main/LICENSE) &copy; 2021 Murshid Azher.
