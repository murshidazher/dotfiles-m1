# Mac OS X Setup Guide

These are the steps I like to take on a fresh Mac install to prep it before [installing my dotfiles](https://github.com/murshidazher/dotfiles-m1):

## General

1. Log in, run `Software Update`, apply, restart.
2. Create an Admin user for your use, *disable the guest account*.
3. Log into your new personal Admin user (**only use this now**)
4. Source external HDD, set-up `Time Machine`.

## Preferences

`Apple Icon > System Preferences`:

1. Configure `Trackpad`.
2. Set `Keyboard > Key Repeat > Fast` to `Fast`.
3. Set `Keyboard > Delay Until Repeat` to `Short`.
4. `Sharing` set computer name.

## Security

`Apple Icon > System Preferences > Security & Privacy`:

1. Set `General > Require a password after sleep…` to `Immediately`
2. In `Advanced` set `Require an administrator password...` to ticked.
3. In `Firewall` turn Firewall on.
4. Enable `File Vault`.
5. Set a Firmware password from `macOS Recovery` (⌘-R)

At this point you should be good to go.

## Architecture Setup

> For detailed step by step instruction look into [this](https://cpufun.substack.com/p/setting-up-the-apple-m1-for-native)

You can also set a default machine preference for the arch command using the ARCHPREFERENCE envirable. If an invocation of arch which is being used to invoke another command and there is no architecture being explicitly requested, then the one in $ARCHPREFERENCE will be used.

```sh
$ arch
arm64
$ ARCHPREFERENCE=x86_64 arch   
arm64
$ ARCHPREFERENCE=x86_64 arch machine
i386
```

### Shell completion

You may also need to forcibly rebuild zcompdump:

```sh
rm -f ~/.zcompdump; compinit
```

Additionally, if you receive `zsh compinit: insecure directories` warnings when attempting to load these completions, you may need to run this:

```sh
chmod -R go-w "$(brew --prefix)/share"
```  

## compinit: insecure directories

If you run across this error,

```sh
zsh compinit: insecure directories, run compaudit for list.
Ignore insecure directories and continue [y] or abort compinit [n]?
```

Remove the group-write permissions with,

```sh
compaudit | xargs chmod g-w
```

## Compinit error

- Refer to this [stackoverflow](https://stackoverflow.com/questions/65747286/zsh-problem-compinit503-no-such-file-or-directory-usr-local-share-zsh-site)

```txt
compinit:503: no such file or directory: /usr/local/share/zsh/site-functions/_asdf
compinit:503: no such file or directory: /usr/local/share/zsh/site-functions/_brew
compinit:shift:505: shift count must be <= $#
```

```sh
ln -fsv /opt/homebrew/completions/zsh/_brew /usr/local/share/zsh/site-functions/_brew
ln -fsv /opt/homebrew/opt/asdf/etc/bash_completion.d/asdf.bash /opt/homebrew/completions/zsh/_asdf
ln -fsv /opt/homebrew/completions/zsh/_asdf /usr/local/share/zsh/site-functions/_asdf
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
