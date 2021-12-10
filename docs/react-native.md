# react-native

## Build Error Flipper-Glog (0.3.6)

If you run into the following error just follow the instructions,

```sh
$ pod install
...
Installing Flipper-Glog (0.3.6)
[!] /opt/homebrew/bin/bash -c
set -e
...
...
...
checking whether we are using the GNU C++ compiler... yes
...
Developer/SDKs/iPhoneOS15.0.sdk accepts -g... yes
...
checking build system type...
/Users/developer/Library/Caches/CocoaPods/Pods/External/glog/2263bd123499e5b93b5efe24871be317-53372/missing: Unknown `--is-lightweight' option
Try `/Users/developer/Library/Caches/CocoaPods/Pods/External/glog/2263bd123499e5b93b5efe24871be317-53372/missing --help' for more information
configure: WARNING: 'missing' script is too old or missing
Invalid configuration `arm64-apple-darwin20.6.0': machine `arm64-apple' not recognized
configure: error: /bin/sh ./config.sub arm64-apple-darwin20.6.0 failed
```

Upgrade Flipper-Glog to `0.3.9` from `0.3.6`,

```sh
# node_modules/react-native/scripts/react_native_pods.rb
...
versions['Flipper-Glog'] ||= '0.3.9'
```

Add the following lines to the `ios-configure-glog.sh` script,

```sh
# node_modules/react-native/scripts/ios-configure-glog.sh
...
PLATFORM_NAME="${PLATFORM_NAME:-iphoneos}"
CURRENT_ARCH="${CURRENT_ARCH}"

# Fix build on Apple Silicon
wget -O config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD'
wget -O config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'
...
```

### `pod install` incompatible architecture (have 'x86_64', need 'arm64e')

If you run into the following error just follow the instructions,

```text
....
LoadError - dlopen(/Users/murshidazher/.asdf/installs/ruby/3.0.2/lib/ruby/gems/3.0.0/gems/ffi-1.15.4/lib/ffi_c.bundle, 0x0009): tried: '/Users/murshidazher/.asdf/installs/ruby/3.0.2/lib/ruby/gems/3.0.0/gems/ffi-1.15.4/lib/ffi_c.bundle' (mach-o file, but is an incompatible architecture (have 'x86_64', need 'arm64e')), '/usr/local/lib/ffi_c.bundle' (no such file), '/usr/lib/ffi_c.bundle' (no such file) - /Users/murshidazher/.asdf/installs/ruby/3.0.2/lib/ruby/gems/3.0.0/gems/ffi-1.15.4/lib/ffi_c.bundle
<internal:/Users/murshidazher/.asdf/installs/ruby/3.0.2/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
...
...
/Users/murshidazher/.asdf/installs/ruby/3.0.2/lib/ruby/gems/3.0.0/gems/cocoapods-1.11.2/bin/pod:55:in `<top (required)>'
/Users/murshidazher/.asdf/installs/ruby/3.0.2/bin/pod:23:in `load'
/Users/murshidazher/.asdf/installs/ruby/3.0.2/bin/pod:23:in `<main>'
```

Do the following,

```sh
# uninstall cocoapods and ffi
$ gem list --local | grep cocoapods | awk '{print $1}' | xargs sudo gem uninstall
$ sudo gem uninstall ffi
$ rm -rf ~/.cocoapods/

# restart the Rosetta terminal
$ sudo xcode-select --switch /Applications/Xcode.app
$ pod install
```
