# asdf

> Packages installed using `asdf`.

- Java
- Maven
- Python2
- Python3
- NodeJs

## Python

```sh
$ sudo ln -s -f $(which python3) $(which python)
$ which python
/Users/murshidazher/.asdf/shims/python
```

## NodeJS

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

## Ruby

```sh
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby 2.7.4
asdf global ruby 2.7.4
gem install bundler:2.2.19 -n /usr/local/bin
gem install --user-install ffi -- --enable-libffi-alloc
```
