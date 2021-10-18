# [dotfiles-m1](https://github.com/murshidazher/dotfiles-m1)

TBA

## Installing / Getting started

> ⚠️ Scripts in this project performs automated tasks. Review the code first and use at your own risk!

### Setup

To setup simply open the terminal, then:

```sh
zsh -c "`curl -L https://git.io/dotfiles-m1`"
```

### Homebrew

- `/usr/local` on macOS intel
- `/opt/homebrew` on macOS ARM
- `/home/linuxbrew` on Linux

```sh
if [[ "$(uname -m)" == "arm64" ]]; then
  export PATH="/opt/homebrew/bin:${PATH}"
fi
```

## TODO

- [ ] https://firebase.google.com/docs/app-distribution/ios/distribute-fastlane

## License

[MIT](https://github.com/murshidazher/dotfiles-m1/blob/main/LICENSE) &copy; 2021 Murshid Azher.
