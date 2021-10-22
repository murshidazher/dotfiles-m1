# [dotfiles-m1](https://github.com/murshidazher/dotfiles-m1)

TBA

## Installing / Getting started

> ⚠️ Scripts in this project performs automated tasks. Review the code first and use at your own risk!

### Setup

To setup simply open the terminal, then:

```sh
bash -c "`curl -L https://git.io/dotfiles-m1`"
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

## TODO

- [ ] https://firebase.google.com/docs/app-distribution/ios/distribute-fastlane
- [ ] change zsh_prompt color profile
- [ ] setting up nodejs before v16 in m1. Build them from binaries. Refer [this](https://github.com/asdf-vm/asdf-nodejs/issues/78#issuecomment-842771319)

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
$ asdf plugin add ant
$ asdf list-all ant
$ asdf install ant latest
$ asdf global ant latest
$ ant -version
```

## License

[MIT](https://github.com/murshidazher/dotfiles-m1/blob/main/LICENSE) &copy; 2021 Murshid Azher.
