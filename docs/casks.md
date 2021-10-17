# Homebrew Cask Commands

> Upgrade / Update outdated casks installed.

- A list of commands to upgrade and update outdated casks.

```sh
# List installed brew casks using the versions flag
> brew list --cask --versions

# List outdated brew casks using the greedy flag (i use this one)
> brew outdated --cask --greedy

# List outdated brew casks using the greedy flag and pipe to show only latest versions
> brew outdated --cask --greedy | grep -v '(latest)'

# List outdated brew casks
> brew outdated --cask

# List outdated brew casks using the verbose flag
> brew outdated --cask --verbose

# Force update
> brew upgrade --cask --verbose --force <name_of_cask>
```

## *-config

- If you get a config error then [read this](https://hashrocket.com/blog/posts/keep-anaconda-from-constricting-your-homebrew-installs)
