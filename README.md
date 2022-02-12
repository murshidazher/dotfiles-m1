<img src="https://raw.githubusercontent.com/murshidazher/dotfiles-m1/main/docs/images/logo.jpg" width="90px">

# [dotfiles-m1](https://github.com/murshidazher/dotfiles-m1)

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/murshidazher/dotfiles-m1/MacOS%20Agent%20build?style=flat-square)

> My personal installation script to automate any new macOS system setup so I don't need to feel poor.

- A dogmatic script to set up my mac. Built for Mac OS X :fire: :fire:

<img src="https://raw.githubusercontent.com/murshidazher/dotfiles-m1/main/docs/images/vscode.png" width="600px">

## Table of Contents

- [dotfiles-m1](#dotfiles-m1)
  - [Table of Contents](#table-of-contents)
  - [Installing / Getting started](#installing--getting-started)
    - [Setup](#setup)
      - [GPG key with Keybase.io](#gpg-key-with-keybaseio)
    - [Homebrew](#homebrew)
    - [Python](#python)
    - [NodeJS](#nodejs)
    - [ASDF Ruby](#asdf-ruby)
    - [Projects](#projects)
    - [Ant](#ant)
    - [Ndk Setup](#ndk-setup)
    - [Fixing xcode path issue](#fixing-xcode-path-issue)
    - [Run React Native App](#run-react-native-app)
      - [iOS setup](#ios-setup)
      - [Clean install pods](#clean-install-pods)
    - [Shell completion](#shell-completion)
    - [Compinit error](#compinit-error)
  - [Vscode error](#vscode-error)
  - [QuickLook Plugin](#quicklook-plugin)
  - [Vscode Permission error when installing extensions](#vscode-permission-error-when-installing-extensions)
  - [Custom bash prompt](#custom-bash-prompt)
  - [TODO](#todo)
  - [License](#license)

## Installing / Getting started

> ⚠️ Scripts in this project performs automated tasks. Review the code first and use at your own risk! ⚠️

### Setup

> The script creates a centrally managed `dotfiles` directory on the `~` of the file system.

To setup simply open the terminal, then:

```sh
$ bash -c "`curl -L https://git.io/dotfiles-m1`"
# after initial setup
$ cd dotfiles && ./setup.sh
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
$ sudo ln -s -f $(which python3) $(which python)
$ which python
/Users/murshidazher/.asdf/shims/python
```

### NodeJS

> 💡 Support for Apple silicon is `15.x` and above.

Open rosetta terminal,

```sh
# to install older binaries of nodejs
$ NODEJS_CONFIGURE_OPTIONS='--with-intl=full-icu --download=all' NODEJS_CHECK_SIGNATURES="no" asdf install nodejs ref:v12.16.1
$ cd ~/.asdf/installs/nodejs
$ ln -s ref-v12.16.1 12.16.1
$ asdf reshim
$ asdf global nodejs 12.16.1
```

### ASDF Ruby

```sh
$ asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
$ asdf install ruby 2.7.4
$ asdf global ruby 2.7.4
$ gem install bundler:2.2.19 -n /usr/local/bin
$ gem install --user-install ffi -- --enable-libffi-alloc
```

### Projects

```sh
$ npm rebuild node-sass
```

### Ant

```sh
$ asdf plugin add ant
$ asdf list-all ant
$ asdf install ant latest
$ asdf global ant latest
$ ant -version
```

### Ndk Setup

> 💡 Install an older NDK version `(20.*.* or lower)` from android studio.

<img src="https://raw.githubusercontent.com/murshidazher/dotfiles-m1/main/docs/images/ndk-tools.png" width="600px">

Installing an older NDK version `(20.*.* or lower)` will prevent the following flutter and react-native build errors,

```sh
FAILURE: Build failed with an exception.

*   What went wrong:
    Execution failed for task ':app:stripDebugDebugSymbols'.

> No toolchains found in the NDK toolchains folder for ABI with prefix: arm-linux-androideabi

*   Try:
    Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output. Run with --scan to get full insights.

*   Get more help at [https://help.gradle.org](https://help.gradle.org)

BUILD FAILED in 1m 4s
Exception: Gradle task assembleDebug failed with exit code 1
```

### Fixing xcode path issue

```sh
$ sudo xcode-select --print-path
# if it something like /Library/Developer/..
$ sudo xcode-select --switch /Applications/Xcode.app
```

### Run React Native App

```sh
# install and link (to install native dependencies)
$ asdf local nodejs 14.18.1
$ npm i
$ react-native link

# create a .dev.env file inside
$ npm run setupEnv
$ npm run start # start the metro bundler
$ npm run android:qa
```

#### iOS setup

Known issues;
- https://github.com/facebook/react-native/pull/32486/files
- https://github.com/facebook/react-native/tree/0.68-stable

```sh
# clean previous installs of ffi and cocoapods
$ gem list --local | grep cocoapods | awk '{print $1}' | xargs sudo gem uninstall
$ sudo gem uninstall ffi
$ rm -rf ~/.cocoapods/

# install ffi and cocoapods
$ sudo arch -x86_64 gem install ffi
$ sudo arch -x86_64 gem install cocoapods

# pod install inside the react-native project folder
$ cd react-native-owner-app/ios
$ pod install
```

#### Clean install pods

```sh
$ cleanpod # will clean install pods
```

### Shell completion

You may also need to forcibly rebuild zcompdump:

```sh
$ rm -f ~/.zcompdump; compinit
```

Additionally, if you receive `zsh compinit: insecure directories` warnings when attempting to load these completions, you may need to run this:

```sh
$ chmod -R go-w "$(brew --prefix)/share"
```  

### Compinit error

- Refer to this [stackoverflow](https://stackoverflow.com/questions/65747286/zsh-problem-compinit503-no-such-file-or-directory-usr-local-share-zsh-site)

```txt
compinit:503: no such file or directory: /usr/local/share/zsh/site-functions/_asdf
compinit:503: no such file or directory: /usr/local/share/zsh/site-functions/_brew
compinit:shift:505: shift count must be <= $#
```

```sh
$ ln -fsv /opt/homebrew/completions/zsh/_brew /usr/local/share/zsh/site-functions/_brew
$ ln -fsv /opt/homebrew/opt/asdf/etc/bash_completion.d/asdf.bash /opt/homebrew/completions/zsh/_asdf
$ ln -fsv /opt/homebrew/completions/zsh/_asdf /usr/local/share/zsh/site-functions/_asdf
```

## Vscode error

When attempting to launch vscode using the `code .` command you might get the following error,

```sh
/usr/local/bin/code: line 10: ./MacOS/Electron: No such file or directory
```

This most likely occurs because of error in python path, symlink the python path manually,

```sh
$ sudo ln -s -f $(which python2) $(which python)
```

## QuickLook Plugin

> “QLStephen.qlgenerator” can’t be opened because Apple cannot check it for malicious software.

Issue the following command to alleviate the issue, effectively marking the QLGenerator as safe:

```sh
$ sudo xattr -cr ~/Library/QuickLook/*.qlgenerator
# reset quicklookd
$ qlmanage -r
$ qlmanage -r cache
```

## Vscode Permission error when installing extensions

Permission error encountered when updating vscode extensions,

```sh
$ sudo chown -R $(whoami):staff $HOME/Library/Application\ Support/CodeCachedExtensionVSIXs
$ sudo chown -R $(whoami):staff $HOME/.vscode/extensions/*
```

## Custom bash prompt

When your current working directory is a Git repository, the prompt will display the checked-out branch's name (and failing that, the commit SHA that HEAD is pointing to). The state of the working tree is reflected in the following way:

| Symbol | Description                      |
|--------|----------------------------------|
| +      | Uncommitted changes in the index |
| !      | Unstaged changes                 |
| ?      | Untracked files                  |
| $      | Stashed files                    |

Further details are in the `.zsh_prompt` file.

<img src="https://raw.githubusercontent.com/murshidazher/dotfiles-m1/main/docs/images/terminal.png" width="600px">

## TODO

- [ ] Refactor: the initialize script
- [ ] Refactor: Add common configurations to docs directory
- [ ] https://firebase.google.com/docs/app-distribution/ios/distribute-fastlane
- [ ] [Example multiple macOS github workflow](https://github.com/IronCoreLabs/recrypt-node-binding/blob/main/.github/workflows/publish.yaml)
- [x] Make `lib.sh` as a curl file to include in initialize.sh
- [x] Uncomment the `initialize.sh` setup
- [x] Update github workflow to check the initialize script.
- [ ] Add [bats](https://github.com/sstephenson/bats) test files to check the scripts and replace the ci checks in the script files
- [ ] Autoformat shell files using `brew install shfmt && shfmt -l -w script.sh`

## License

[MIT](https://github.com/murshidazher/dotfiles-m1/blob/main/LICENSE) &copy; 2021-2022 Murshid Azher.
