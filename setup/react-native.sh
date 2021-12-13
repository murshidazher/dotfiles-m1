#!/usr/bin/env bash

# TODO: Script under process
# https://www.chrisjmendez.com/2021/05/12/how-to-install-flutter-on-mac-osx-using-homebrew/
# https://reactnative.dev/docs/environment-setup
# https://stackoverflow.com/questions/64907154/android-studio-emulator-on-macos-with-arm-cpu-m1
# https://gist.github.com/bluenex/96a31acfebea4ad7b1b927b7125e4569
# https://gist.github.com/patrickhammond/4ddbe49a67e5eb1b9c03
# https://gist.github.com/ThePredators/064c46403290a6823e03be833a2a3c21
# https://gist.github.com/mrk-han/66ac1a724456cadf1c93f4218c6060ae - install skins
# https://www.py4u.net/discuss/626303
# https://gist.github.com/badsyntax/ce848ab40b952d944c496575d40e5427 - run on azure pipelines (extract the config.ini) setup
# TODO: Explore and add script to manage avd_skins to emulator programatically.
# Needs for exploration on setting up ios development environment

debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./lib.sh
fi

# Load homebrew config if not already loaded.
if [ -z ${hbwloaded+x} ]; then
  source ../zsh.d/homebrew
fi

# Set defaultdotfilesdir var if not declared.
if [ -z ${defaultdotfilesdir+x} ]; then
  defaultdotfilesdir="$HOME/dotfiles"
fi

bot "OK, what we're going to do:\n"
actioninfo "1. Install all dependencies for working with react native."
actioninfo "2. Install android studio and setup the Andorid SDK v31."
actioninfo "3. Configure xcode and cocoapods to work with flutter."

ask_for_confirmation "Ready?"
if answer_is_yes; then
  ok "Let's go."
else
  cancelled "Exit."
  exit -1
fi

# --------
# 1. Basic
# --------

# used by facebook to watch for file changes
brew install watchman

# ----------
# 2. Android
# ----------
# brew install --cask android-platform-tools # for adb

# Android studio
brew install --cask android-studio

touch ~/.android/repositories.cfg


# setup the env to java 1.8 for sdkmanager
# bash -c 'JAVA_HOME=$(/usr/libexec/java_home -v 1.8)'
# bash -c 'INTEL_HAXM_HOME=/usr/local/Caskroom/intel-haxm'

# If you have install android studio
# https://stackoverflow.com/questions/17963508/how-to-install-android-sdk-build-tools-on-the-command-line#answer-22862021
# The avdmanager command is present in both
# Add this to path if you need sdkmanager and avdmanager, if you installed Android Studio
# ~/Library/Android/sdk/tools/bin
# ~/Library/Android/sdk/cmdline-tools/latest/bin
# Note: To create devices with the latest devices configuration including Pixel 4 XL, you have to use the avdmanager tool present in cmdline-tools/bin folder
# ./tools/android list sdk --all
# ./tools/android list avd

sdkmanager --update
sdkmanager "platform-tools" "platforms;android-31"
sdkmanager "build-tools;31.0.0"
sdkmanager "sources;android-31"
sdkmanager "extras;android;m2repository"
sdkmanager "extras;google;m2repository"
sdkmanager --install "ndk;20.1.5948994"

sdkmanager --licenses

# -------------
# 2.1. Emulator
# -------------

action "update sdk manager"
sdkmanager --update

action "download system images for android emulator"
# sdkmanager --list | grep "system-images.*playstore"

# For m1 macbooks
local SYSTEM_IMAGE_ARM_VERSION="system-images;android-31;google_apis;arm64-v8a"
local SYSTEM_IMAGE_ARM_PLAY_VERSION="system-images;android-31;google_apis_playstore;arm64-v8a"
sdkmanager ${SYSTEM_IMAGE_ARM_VERSION}
sdkmanager ${SYSTEM_IMAGE_ARM_PLAY_VERSION}

action "create an AVD using Pixel 2"

# Create an AVD using Pixel 2
# https://developer.android.com/studio/command-line/avdmanager
# https://developer.android.com/studio/run/emulator-commandline
# Note: use 'avdmanager list device' to get the device id
avdmanager --verbose create avd --force --name "Pixel_4_API_31_Play" --device "pixel_4" --package ${SYSTEM_IMAGE_ARM_PLAY_VERSION} -c 2048M --tag "google_apis_playstore"

# Note: If you've installed Android Studio, and need to create avd manually
# Android Studio -> More actions -> AVD Manager -> Select Pixel 2 Image
# Create Virtual Device -> Select x86 Images Tab -> Q 29 (would be already downloaded) -> Next -> Finish

# Starting the emulator manually
# emulator @Pixel_4_API_31_Play -wipe-data -verbose -logcat '*:e *:w' -netfast -no-boot-anim -no-audio -no-window -skin 480x800
# alias avd-samsung='emulator @Pixel_4_API_31_Play -no-boot-anim -netfast -no-snapshot -wipe-data -skin 768x1280 -memory 2048 &'

# Add keyboard forwarding, to enable keyboard keypress to be sent to emulator.
for file in ~/.android/avd/*avd; do
  if cat $file/config.ini | grep "hw.keyboard=yes" >/dev/null; then
    success "✔ hw.keyboard is already added to $(basename $file)"
  else
    echo "hw.keyboard=yes" >>$file/config.ini
    success "✔ hw.keyboard=yes is added to $(basename $file)"
  fi
done

# ----------
# 3. Flutter
# ----------

flutter precache
flutter doctor --android-licenses

runnning "Install XCode from MacStore"
read -p "Press [Enter] key when done..."

mas install 497799835 # xcode
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
sudo xcodebuild -license
open -a Simulator
sudo gem install cocoapods
sudo gem install ffi
pod setup

# skia
# https://developer.android.com/studio/run/emulator-acceleration
# Note: ARM based chipset (M1) can't use hardware acceleration

su
setprop debug.hwui.renderer skiagl
stop
start

flutter doctor

# ---------------
# 4. React native
# ---------------

if hash asdf 2>/dev/null; then

  local LATEST_NODEJS_14_VERSION=$(asdf list nodejs | grep '^  14\.' | tail -1 | sed 's: ::g')
  asdf local nodejs ${LATEST_NODEJS_14_VERSION}
  asdf reshim nodejs # to have all the globally install packages in PATH
  npm install -g react-native-cli

  # to see connected android devices
  # adb devices

  # fin.
else
  echo "WARNING: asdf not found."
fi

# --------
# 5. Misc.
# --------

# https://gist.github.com/ThePredators/a1d105b0794198cade4ef2b0e0836541
# gem install bundler
# brew install fastlane

# bundle init
# bundle update



