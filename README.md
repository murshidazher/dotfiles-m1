<img src="https://raw.githubusercontent.com/murshidazher/dotfiles-m1/main/docs/images/logo.png" width="90px">

# [dotfiles-m1](https://github.com/murshidazher/dotfiles-m1)

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/murshidazher/dotfiles-m1/MacOS%20Agent%20build?style=flat-square)
![Code Linter](https://img.shields.io/static/v1?label=lint&message=shellcheck&color=FFF1CE&style=flat-square)
![Code Style](https://img.shields.io/static/v1?label=style&message=shfmt&color=FFF2F9&style=flat-square)

![Repository Size](https://img.shields.io/endpoint?style=flat-square&url=https://gist.githubusercontent.com/murshidazher/549abdf9bf6da79a63605fd3ab9574fc/raw/size-badge.json)
![Regression Runtime](https://img.shields.io/endpoint?style=flat-square&url=https://gist.githubusercontent.com/murshidazher/549abdf9bf6da79a63605fd3ab9574fc/raw/elapsed-curl-badge.json)
![Min. Disk Space Occupied](https://img.shields.io/endpoint?style=flat-square&url=https://gist.githubusercontent.com/murshidazher/549abdf9bf6da79a63605fd3ab9574fc/raw/minimum-disk-space-occupied-badge.json)
![Last Regression Date](https://img.shields.io/endpoint?style=flat-square&url=https://gist.githubusercontent.com/murshidazher/549abdf9bf6da79a63605fd3ab9574fc/raw/regression-date-badge.json)

> My personal installation script to automate any new macOS system setup so I don't need to feel poor.

- A dogmatic script to set up my mac. Built for Mac OS X :fire: :fire:
- The minimum storage space and runtime are only estimates; they may vary from machine to machine.
- ⚠️ Still on experimental stage hence run at your own risk. ⚠️

<img src="https://raw.githubusercontent.com/murshidazher/dotfiles-m1/main/docs/images/vscode.png" width="600px">

## Table of Contents

- [dotfiles-m1](#dotfiles-m1)
  - [Table of Contents](#table-of-contents)
  - [Installing / Getting started](#installing--getting-started)
    - [Setup](#setup)
    - [Developing](#developing)
      - [Linting](#linting)
    - [Sensible macOS defaults](#sensible-macos-defaults)
      - [GPG key with Keybase.io](#gpg-key-with-keybaseio)
    - [Projects](#projects)
    - [Ant](#ant)
    - [Ndk Setup](#ndk-setup)
    - [Fixing xcode path issue](#fixing-xcode-path-issue)
    - [Run React Native App](#run-react-native-app)
      - [iOS setup](#ios-setup)
      - [Clean install pods](#clean-install-pods)
  - [Custom bash prompt](#custom-bash-prompt)
  - [Notes](#notes)
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

### Developing

- Make sure to lint the files prior to committing it.

#### Linting

> 💡 We make use of `shellcheck` and `shfmt` to lint the shell scripts,

Install the linters,

```sh
brew install shellcheck
brew install shfmt
```

Lint the files before making a PR,

```sh
shellcheck <file>.sh
shfmt -l -w -s <file>.sh # style linting
```

### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```sh
./macos/.macos
```

#### GPG key with Keybase.io

- Follow this gist to [setup gpgkey with keybase.io](https://github.com/pstadler/keybase-gpg-github).

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

## Notes

- Creating a [custom git hook](https://help.gitkraken.com/gitkraken-client/githooksexample/) 

## TODO

- [ ] Refactor: the initialize script
- [ ] Refactor: Add common configurations to docs directory
- [ ] Auto-format shell files using `brew install shellcheck && brew install shfmt && shfmt -l -w script.sh`
- [ ] Check precommit hook for [linting](https://github.com/jumanjihouse/pre-commit-hooks#configure-pre-commit)
- [ ] Dynamically add inputs to the buffer and check the initialize script
- [ ] Run react-native setup as separate workflow.
- [ ] Check on `dotfilesdir="$HOME/${PWD##*/}"` and see if it really works on all files.

## License

[MIT](https://github.com/murshidazher/dotfiles-m1/blob/main/LICENSE) &copy; 2021-2022 Murshid Azher.
