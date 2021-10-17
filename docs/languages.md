# Languages

## Java

```sh
> asdf plugin-add java
> asdf list-all java
> asdf install java corretto-15.0.2.7.1
> asdf global java corretto-15.0.2.7.1
```

```sh
JAVA_HOME=". ~/.asdf/plugins/java/set-java-home.bash"
```

### httpie

```sh
> http PUT httpbin.org/put X-API-Token:123 name=John
```


## AndroidStudio

```sh
> brew install gradle # openjdk	15.0.1
> brew install --cask android-studio
# Android 
export ANDROID_HOME="/usr/local/share/android-sdk"
export ANDROID_SDK_ROOT=/Users/ciandroid/android-sdk-macosx
export PATH=$PATH:$ANDROID_SDK_ROOT/tools
```

## PDF Convert

```
> convert 1.png 2.png -compress jpeg -quality 50 Result.pdf
> convert *.png -compress jpeg -quality 50 Result.pdf
> convert *.png 2.png -resample 300 Result.pdf
```
