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
