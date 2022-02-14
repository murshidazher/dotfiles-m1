#!/usr/bin/env bash

# 1. Backup
# 2. Directories
# 3. Xcode CLI
# 4. Homebrew
# 5. Rosetta
# 6. Symlinks
# 7. Web development
# 8. Mobile development
# 9. Cron tasks
# 10. Misc.

debug=${1:-false}     # default debug param.
source ./setup/lib.sh # load help lib.

# Help
bot "OK, what we're going to do:\n"

actioninfo "1. Backup directories and files we'll be touching."
actioninfo "2. Create required directories."
actioninfo "3. Install Xcode Command Line Tools."
actioninfo "4. Install Rosetta 2 for Intel based binaries."
actioninfo "5. Install Homebrew and all required apps."
actioninfo "6. Create symlinks for directories and files."
actioninfo "7. Environment Setup for web development."
actioninfo "8. Environment Setup for mobile development."
actioninfo "9. Cron Task setup."
actioninfo "10. Final touches."

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

# ------------
# 4. Rosetta
# ------------
botintro "\e[1mSTEP 4: Rosetta\e[0m"
source ./setup/rosetta.sh

# -----------
# 5. Homebrew
# -----------

if !is_ci || [[ ! -z "${RUN_SETUP_HOMEBREW}" ]]; then
  botintro "\e[1mSTEP 5: HOMEBREW\e[0m"
  source ./setup/brew.sh

  # brew is required to continue, exit out otherwise.
  if ! $brewinstall; then
    cancelled "\e[1mCannot proceed. Exit.\e[0m"
    exit 1
  fi
fi

# -----------
# 6. Symlinks
# -----------
botintro "\e[1mSTEP 6: SYMLINKS\e[0m"
source ./setup/symlinks.sh

# ------------------
# 7. Web Environment
# ------------------

botintro "\e[1mSTEP 7: Environment Setup for web development.\e[0m"

# asdf setup
source ./setup/asdf.sh

# Note: asdf minimal setup (alternative for the asdf full setup)
# source ./setup/asdf-minimal.sh

# Node setup
source ./setup/node.sh

# vim setup
source ./setup/vim.sh

# miniconda setup
source ./setup/miniconda.sh

# vscode setup
source ./setup/vscode.sh

# chrome extensions setup
source ./setup/chrome.sh

# ---------------------
# 8. Mobile Environment
# ---------------------
botintro "\e[1mSTEP 8: Environment Setup for mobile development.\e[0m"
source ./setup/react-native.sh

# -------------
# 9. CRON Tasks
# -------------

botintro "\e[1mSTEP 9: Scheduling crontab tasks\e[0m"
source ./setup/cron.sh

# --------
# 10. Misc.
# --------
botintro "\e[1mSTEP 10: Final touches\e[0m"
source ./setup/misc.sh

# Wrap-up.

botintro "\e[1mFINISHED\e[0m -- That's it for the automated process."

echo -e "\np.s. don't forget to sync your dropbox and get mackup running.\n"
# EOF
