# Visual Studio Code Extensions

This markdown lists all the default extensions installed by the script.

- `:emojisense:` by Matt Bierner
- `Auto Close Tag` by Jun Han
- `Auto Import` by steoates
- `Auto Import - ES6, TS, JSX, TSX` by Sergey Korenuk
- `Auto Rename Tag` by Jun Han
- `Beautify` by HookyQR
- `Better TOML` by bungcip
- `C/C++` by Microsoft
- `Code Runner` by Jun Han
- `Code Spell Checker` by Street Side Software
- `Code Highlight` by Sergil Naumov
- `CSS Compressor` by bestvow
- `css-compact` by jsonchou
- `Docker` by Microsoft
- `EditorConfig for VS Code` by EditorConfig
- `ESLint` by Dirk Baeumer
- `Excel Viewer` by GrapeCity
- `file-icons` by file-icons
- `Github Markdown Preview` by Matt Bierner
- `GitLens — Git supercharged` by Eric Amodio
- `hex-rgba converter` by medzhidov
- `htmltagwrap` by Brad Gashler
- `Import Cost` by Wix
- `Insert Date String` by Jakub Synowiec
- `IntelliSense for CSS class names` by Zignd
- `Svelte for VS Code` by Svelte
- `Svelte Intellisense` by ardenivanov
- `vscode-styled-components` by Julien Poissonnier
- `YAML` by Red Hat
- `Dash` by Budi Irawan
- `HashiCorp Terraform` by HashiCorp
- `Todo Tree` by Gruntfuggly

## Vscode Permission error when installing extensions

Permission error encountered when updating vscode extensions,

```sh
sudo chown -R $(whoami):staff $HOME/Library/Application\ Support/CodeCachedExtensionVSIXs
sudo chown -R $(whoami):staff $HOME/.vscode/extensions/*
```

## Vscode error for Python

When attempting to launch vscode using the `code .` command you might get the following error,

```sh
/usr/local/bin/code: line 10: ./MacOS/Electron: No such file or directory
```

This most likely occurs because of error in python path, symlink the python path manually,

```sh
sudo ln -s -f $(which python2) $(which python)
```
