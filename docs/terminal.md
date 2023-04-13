# Terminal

## iTerm2 Color Profile

Go to iTerm 2 > Settings > Profile > Press `... (Other Actions)` > Import JSON Profiles > Select `~/dotfiles/nord-iterm2.json` > Select the imported profile > Press `... (Other Actions)` > Set as Default > Close and Re-open iterm

## Terminal Color Profile

Go to Terminal > Settings > Profile > Press `...` > Import > Select `~/dotfiles/terminal/Nord.terminal` > Press `Default` > Close and Re-open terminal

## `shopt` not found

> command not found: `shopt`

```sh
echo "#! /bin/bash\n\nshopt \$*\n" > /usr/local/bin/shopt
chmod +x /usr/local/bin/shopt
ln -s /usr/local/bin/shopt /usr/bin/shopt
echo "alias shopt='/usr/bin/shopt'" >> ~/.zshrc
```
