# Utilities

## Fonts

To list out all fonts that you can install,

```sh
> brew search "/font-/"
```

## Intel HAXM

You might need to add these into your `.zshrc` or `.bash_profile` files if you get complaints about `haxm` or `java`.

```sh
export INTEL_HAXM_HOME=/usr/local/Caskroom/intel-haxm
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
```

And check the flutter version after the setup,

```sh
> flutter doctor -v
```

## Android Skins

> 💡 You might be able to use Samsung emulator skins by downloading the skins from [developer.samsung.com](https://developer.samsung.com/galaxy-emulator-skin). More documentation on [avdmanager](https://developer.android.com/studio/command-line/avdmanager).

- For installation instruction, follow this [video](https://www.youtube.com/watch?v=2vtelVClQOo) or [this](https://www.youtube.com/watch?v=r-mvUmhzgA4).
- For installtion using Android Studio, follow [this](https://youtu.be/6JIPsZpIJzE) or this [video](https://www.youtube.com/watch?v=o0FyyKNaF9A)

## mkcert

> 💡 For more information about setting up, go through the following docs. [ubuntu setup](https://kifarunix.com/create-locally-trusted-ssl-certificates-with-mkcert-on-ubuntu-20-04/) or [running Jekyll](https://diamantidis.github.io/tips/2020/06/26/serve-localhost-website-on-https-with-mkcert).

`mkcert` is a simple tool for making locally-trusted development certificates. It requires no configuration.

```sh
> mkcert -install
> mkcert example.com "*.example.com" example.test localhost 127.0.0.1 ::1
> mkcert -key-file key.pem -cert-file cert.pem localhost # create files relative
> mkcert -uninstall
```

## Astah UML

```sh
> brew install --cask astah-uml
```

## Zotero

For research

```sh
> brew install --cask zotero
```

## MS office

```sh
> brew install --cask microsoft-office # if we need all packages
> brew install --cask microsoft-word 
> brew install --cask microsoft-excel
> brew install --cask microsoft-powerpoint
> brew install --cask microsoft-teams
> brew install --cask microsoft-auto-update # for updates
> brew upgrade # single command to update all apps
> brew update # updates homebrew casks
> bwclean # to clean all cache of homebrew for optimal performance
```

## Google Drive

```sh
> brew install --cask google-drive-file-stream # google drive
> brew uninstall google-drive-file-stream
> brew install google-drive
```
