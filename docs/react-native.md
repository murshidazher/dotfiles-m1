# react-native

## Build Error Flipper-Glog (0.3.6)

> 🔗 Link to the [issue](https://github.com/facebook/react-native/pull/32486/files) and fixed stable [v68.0.0](https://github.com/facebook/react-native/tree/0.68-stable)

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

### Solution 1

Check your ruby version,

```sh
$ ruby -v
# ruby 3.0.2p107 (2021-07-07 revision 0db68f0233) [arm64-darwin21]
```

If your architecture is `arm64-darwin<version>`, then you might need to uninstall ruby and depend on the native installed ruby version

```sh
$ asdf uninstall ruby 3.0.2
$ sudo rm -rf ~/.gem/ruby/ # remove leftover gems
$ sudo gem pristine msgpack --version 1.4.2 # update gems to pristine condition
$ ruby -v
# ruby 2.6.8p205 (2021-07-07 revision 67951) [universal.arm64e-darwin21]
```

Install all react-native dependencies,

```sh
# clean previous installs of ffi and cocoapods
$ rm -rf ~/.cocoapods/

# install ffi and cocoapods
$ sudo arch -x86_64 gem install ffi
$ sudo arch -x86_64 gem install cocoapods
$ sudo gem install ethon
```

Now, do a clean install,

```sh
$ cd <react-native-app>
$ cd ios
$ cleanpod # a function alias found in zsh/.functions
```

### Solution 2

> 💡 Use this solution only if you don't want to use the universal ruby build but need to use the latest `arm64` based build.

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

> 🔗 Link to the [issue](https://github.com/CocoaPods/CocoaPods/issues/10220)

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
