#!/usr/bin/env bash
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  # shellcheck source=setup/lib.sh
  source ./setup/lib.sh
fi

# Load homebrew config if not already loaded.
if [ -z ${hbwloaded+x} ]; then
  # shellcheck source=zsh.d/homebrew
  source ./zsh.d/homebrew
fi

# Set dotfilesdir var if not declared.
if [ -z ${dotfilesdir+x} ]; then
  dotfilesdir="$HOME/${PWD##*/}"
fi

# Set defaultdotfilesdir var if not declared.
if [ -z ${defaultdotfilesdir+x} ]; then
  defaultdotfilesdir="$HOME/dotfiles"
fi

bot "OK, what we're going to do:\n"
actioninfo "1. Install all dependencies for working with react native."
actioninfo "2. Install android studio and setup the Andorid SDK v31."
actioninfo "3. Configure xcode and cocoapods."
actioninfo "4. Install react native global package."

ask_for_confirmation "Ready?"
if answer_is_yes || is_ci; then
  ok "Let's go."
else
  cancelled "Exit."
  exit 1
fi

# --------
# 1. Basic
# --------

# used by facebook to watch for file changes
brew install watchman

# ----------
# 2. Android
# ----------

# Android studio
brew install --cask android-studio

touch ~/.android/repositories.cfg

# Load android config.
# shellcheck source=android/.androidrc
source ./android/.androidrc

# add Andorid tools to commandline
PATH="$PATH:$ANDROID_HOME/emulator"
PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
PATH="$PATH:$ANDROID_HOME/tools"
PATH="$PATH:$ANDROID_HOME/tools/bin"
PATH="$PATH:$ANDROID_HOME/platform-tools"
PATH="$PATH:$ANDROID_HOME/build-tools/$(ls $ANDROID_HOME/build-tools | sort | tail -1)"
export PATH

echo $PATH

yes | sdkmanager --update
yes | sdkmanager "platform-tools" "platforms;android-31"
yes | sdkmanager "build-tools;31.0.0"
yes | sdkmanager "sources;android-31"
yes | sdkmanager "extras;android;m2repository"
yes | sdkmanager "extras;google;m2repository"
yes | sdkmanager --install "ndk;21.0.6113669"

yes | sdkmanager --licenses

# -------------
# 2.1. Emulator
# -------------

action "update sdk manager"
yes | sdkmanager --update

action "download system images for android emulator"
# sdkmanager --list | grep "system-images.*playstore"

# For m1 macbooks
SYSTEM_IMAGE_ARM_VERSION="system-images;android-31;google_apis;arm64-v8a"
SYSTEM_IMAGE_ARM_PLAY_VERSION="system-images;android-31;google_apis_playstore;arm64-v8a"
yes | sdkmanager ${SYSTEM_IMAGE_ARM_VERSION}
yes | sdkmanager ${SYSTEM_IMAGE_ARM_PLAY_VERSION}

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
  if cat "$file"/config.ini | grep "hw.keyboard=yes" >/dev/null; then
    success "✔ hw.keyboard is already added to $(basename "$file")"
  else
    echo "hw.keyboard=yes" >>"$file"/config.ini
    success "✔ hw.keyboard=yes is added to $(basename "$file")"
  fi
done

# ---------------------
# 3. Configure Cocapods
# ---------------------

if is_not_ci; then
  runnning "Install XCode from MacStore"
  read -r -p "Press [Enter] key when done..."

  mas install 497799835 # xcode
fi

sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
sudo xcodebuild -license
open -a Simulator

sudo gem install cocoapods
sudo gem install ffi
pod setup

# ---------------
# 4. React native
# ---------------

if hash asdf 2>/dev/null; then

  LATEST_NODEJS_14_VERSION=$(asdf list nodejs | grep '^  14\.' | tail -1 | sed 's: ::g')
  asdf local nodejs "${LATEST_NODEJS_14_VERSION}"
  asdf reshim nodejs # to have all the globally install packages in PATH
  npm install -g react-native-cli

  # to see connected android devices
  # adb devices

  # fin.
else
  echo "WARNING: asdf not found."
fi
