#!/usr/bin/env bash

# 1. Backup
# 2. Directories
# 3. Xcode CLI
# 4. Homebrew
# 5. Symlinks
# 6. Web development
# 7. Mobile development
# 8. Cron tasks
# 9. Misc.

debug=${1:-false}     # default debug param.
source ./setup/lib.sh # load help lib.

# Help
bot "OK, what we're going to do:\n"

actioninfo "1. Backup directories and files we'll be touching."
actioninfo "2. Create required directories."
actioninfo "3. Install Xcode Command Line Tools."
actioninfo "4. Install Homebrew and all required apps."
actioninfo "5. Create symlinks for directories and files."
actioninfo "6. Environment Setup for web development."
actioninfo "7. Environment Setup for mobile development."
actioninfo "8. Cron Task setup."
actioninfo "9. Final touches."

# ---------
# 1. Backup
# ---------
botintro "\e[1mSTEP 1: BACKUP\e[0m"
source ./setup/backup.sh

# --------------
# 2. Directories
# --------------
botintro "\e[1mSTEP 2: DIRECTORIES\e[0m"
source ./setup/directories.sh

# ------------
# 3. Xcode CLI
# ------------
botintro "\e[1mSTEP 3: XCODE CLI\e[0m"
source ./setup/xcodecli.sh

# -----------
# 4. Homebrew
# -----------
botintro "\e[1mSTEP 4: HOMEBREW\e[0m"
source ./setup/brew.sh

# brew is required to continue, exit out otherwise.
if ! $brewinstall; then
  cancelled "\e[1mCannot proceed. Exit.\e[0m"
  exit -1
fi

# asdf setup
source ./setup/asdf.sh

# asdf minimal setup
# source ./setup/asdf-minimal.sh

# Node setup
source ./setup/node.sh

# vim setup
source ./setup/vim.sh

# miniconda setup
source ./setup/miniconda.sh

# -----------
# 5. Symlinks
# -----------
botintro "\e[1mSTEP 5: SYMLINKS\e[0m"
source ./setup/symlinks.sh

# ------------------
# 6. Web Environment
# ------------------

botintro "\e[1mSTEP 6: Environment Setup for web development.\e[0m"

# vscode setup
source ./setup/vscode.sh

# chrome extensions setup
source ./setup/chrome.sh

# ---------------------
# 7. Mobile Environment
# ---------------------
botintro "\e[1mSTEP 7: Environment Setup for mobile development.\e[0m"
source ./setup/react-native.sh

# -------------
# 8. CRON Tasks
# -------------

botintro "\e[1mSTEP 8: Scheduling crontab tasks\e[0m"
source crontab .scripts/cron.txt

# --------
# 9. Misc.
# --------
botintro "\e[1mSTEP 9: Final touches\e[0m"
source ./setup/misc.sh

# Wrap-up.

botintro "\e[1mFINISHED\e[0m -- That's it for the automated process."

echo -e "\np.s. don't forget to sync your dropbox and get mackup running.\n"
# EOF
