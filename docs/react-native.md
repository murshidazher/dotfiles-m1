# react-native

## Build Error Flipper-Glog (0.3.6)

> 💡 Seems like this issue is fixed with the latest version of react native. Archiving this for future references.

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

## `pod install` incompatible architecture (have 'x86_64', need 'arm64e')

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

## Can't find `node` in Xcode build

If you run into the following error just follow the instructions,

```sh
...
++ echo 'error: Can'\''t find the '\''node'\'' binary to build the React Native bundle. ' 'If you have a non-standard Node.js installation, select your project in Xcode, find ' ''\''Build Phases'\'' - '\''Bundle React Native code and images'\'' and change NODE_BINARY to an ' 'absolute path to your node executable. You can find it by invoking '\''which node'\'' in the terminal.'
error: Can't find the 'node' binary to build the React Native bundle.  If you have a non-standard Node.js installation, select your project in Xcode, find  'Build Phases' - 'Bundle React Native code and images' and change NODE_BINARY to an  absolute path to your node executable. You can find it by invoking 'which node' in the terminal.
++ exit 2
```

Make a symlink,

```sh
$ ln -s $(which node) /usr/local/bin/node
```

## iOS: Undefined symbols for architecture x86_64/arm64

> 🔗 Link to the [issue](https://github.com/DataDog/dd-sdk-reactnative/issues/41)

If you run into the following error just follow the instructions,

```sh
Undefined symbols for architecture x86_64:
  "static Foundation.JSONEncoder.OutputFormatting.withoutEscapingSlashes.getter : Foundation.JSONEncoder.OutputFormatting", referenced from:
      static (extension in Datadog):Foundation.JSONEncoder.default() -> Foundation.JSONEncoder in libDatadogSDK.a(JSONEncoder.o)
  "Network.NWPath.isConstrained.getter : Swift.Bool", referenced from:
      closure #2 () -> Swift.Bool? in closure #1 (Network.NWPath) -> () in Datadog.NWPathNetworkConnectionInfoProvider.init(monitor: Network.NWPathMonitor) -> Datadog.NWPathNetworkConnectionInfoProvider in libDatadogSDK.a(NetworkConnectionInfoProvider.o)
  "(extension in Foundation):__C.NSFileHandle.readToEnd() throws -> Foundation.Data?", referenced from:
      Datadog.File.read() throws -> Foundation.Data in libDatadogSDK.a(File.o)
  "(extension in Foundation):__C.NSFileHandle.seekToEnd() throws -> Swift.UInt64", referenced from:
      Datadog.File.append(data: Foundation.Data) throws -> () in libDatadogSDK.a(File.o)
  "(extension in Foundation):__C.NSFileHandle.write<A where A: Foundation.DataProtocol>(contentsOf: A) throws -> ()", referenced from:
      Datadog.File.append(data: Foundation.Data) throws -> () in libDatadogSDK.a(File.o)
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

Search for `LIBRARY_SEARCH_PATHS` and replace,

```sh
# from
LIBRARY_SEARCH_PATHS = (
  "\"$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)\"",
  "\"$(TOOLCHAIN_DIR)/usr/lib/swift-5.0/$(PLATFORM_NAME)\"",
  "\"$(inherited)\"",
);

# to
LIBRARY_SEARCH_PATHS = (
  "\"$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)\"",
  "\"/usr/lib/swift\"",
  "\"$(inherited)\"",
);
```

## Android Error

If you run into the following error just follow the instructions,

```sh
...
Installation error: INSTALL_FAILED_VERSION_DOWNGRADE Please check logcat output for more details. Launch canceled!
```

Uninstall the previous application and rebuild it,

```sh
$ adb uninstall com.different.owner.qa
$ npm run android:qa
```

## AMSupportURL* Errors

> 🔗 Link to the [issue](https://www.reddit.com/r/MacOS/comments/nqgvwg/class_amsupporturlconnectiondelegate_is/hoqz9bb/)

If you run into the following error just follow the instructions,

```sh
$ xcodebuild -list
...
Class AMSupportURLConnectionDelegate is implemented in both /usr/lib/libauthinstall.dylib (0x209986c10) and /System/Library/PrivateFrameworks/MobileDevice.framework/Versions/A/MobileDevice (0x1187bc2b8)
...
```

Uninstall the command line tools and reinstall it,

```sh
$ sudo rm -rf /Library/Developer/CommandLineTools
$ sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
```

If you need to uninstall the xcode completely,

```sh
$ xcode-select --install
$ sudo xcode-select --reset
# or
$ xcode-select -s /Library/Developer/CommandLineTools
```

## iOS Push notifications

Sending push notifications for app in iOS simulator,

Create an example payload file,

```js
{
  "aps": {
    "alert": {
      "title": "Push On Simulator",
      "body": "You have sent it on simulator"
    },
    "badge": 7
  },
  "Simulator Target Bundle": "com.example.app.qa"
}
```

```sh
xcrun simctl list
xcrun simctl push <device-id> ios/payload.apns
```
