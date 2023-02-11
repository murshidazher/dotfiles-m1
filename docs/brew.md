# Homebrew

## Path

> 💡 Locations to find the brew installations

- `/usr/local` on macOS intel
- `/opt/homebrew` on macOS ARM
- `/home/linuxbrew` on Linux

```sh
if [[ "$(uname -m)" == "arm64" ]]; then
  export PATH="/opt/homebrew/bin:${PATH}"
fi
```

## Error: It seems there is already an app at

Sometimes you run into the following error when updating your casks, `reinstall` the app to overcome this issue.

```sh
brew reinstall --cask <app_name>
```
