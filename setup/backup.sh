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

# Load dirs and files if not already loaded.
if [ -z ${filesloaded+x} ]; then
  # shellcheck source=setup/files.sh
  source ./setup/files.sh
  echo -en "\n"
fi

bot "Backup directories and files we'll be touching."

action "Create backup directories"
# Make backup dirs.
backupdir="$HOME/backup"
dotfilesbackupdir="$HOME/backup/dotfiles-backup"

# Declare array of directories.
declare -a backupdirarray=(
  "$backupdir"
  "$dotfilesbackupdir"
)

# Send array to make_directories function.
make_directories "${backupdirarray[@]}"

if $dirsuccess; then
  success "Backup directories created."
else
  error "Errors when creating backup directories, please check and resolve."
  cancelled "Cannot proceed. Exit."
  exit 1
fi

# Backup everything
ask_for_confirmation "Do you need to backup everything ?"
if answer_is_yes; then
  action "Backup directories"
  # Loop array of directories that dotfiles handles, copy them to backup
  for i in "${dotfilesdirarray[@]}"; do
    cp -Rp "${i/$dotfilesdir/$HOME}" "$dotfilesbackupdir"
    print_result $? "Copying ${i/$dotfilesdir/$HOME}"
  done

  action "Backup files"
  # Loop array of directories that dotfiles handles files for
  for i in "${dotfilesfilearray[@]}"; do
    declare -a tmparr=()

    # Properly store the results of find on these directories in an array
    # https://stackoverflow.com/questions/23356779/how-can-i-store-find-command-result-as-arrays-in-bash
    # We want to handle .*, *.cfg, *.conf and NOT .DS_Store, .git, .osx, .macos and no *.sh files
    while IFS= read -r -d $'\0'; do
      tmparr+=("$REPLY")
    done < <(find "$i" -type f -maxdepth 1 \( -name ".*" -o -name "*.cfg" -o -name "*.conf" \) -a -not -name .DS_Store -not -name .git -not -name .osx -not -name .macos -not -name "*.sh" -print0)

    # For each match file in each directory, copy that to backup
    for j in "${tmparr[@]}"; do
      cp -Rp "${j/$i/$HOME}" "$dotfilesbackupdir"
      print_result $? "Copying ${j/$i/$HOME}"
    done
  done
else
  cancelled "Ok, let's only backup the local directories and files".
fi

action "Backup other local directories and files (just incase...)\n"
# Copy other misc $HOME files
cp -Rp ~/.zsh_history "$dotfilesbackupdir"
cp -Rp ~/.extra "$dotfilesbackupdir"
cp -Rp ~/.extra.fish "$dotfilesbackupdir"
cp -Rp ~/.gitconfig.local "$dotfilesbackupdir"
cp -Rp ~/.gnupg "$dotfilesbackupdir"
cp -Rp ~/.nano "$dotfilesbackupdir"
cp -Rp ~/.nanorc "$dotfilesbackupdir"
cp -Rp ~/.netrc "$dotfilesbackupdir"
cp -Rp ~/.ssh "$dotfilesbackupdir"
cp -Rp ~/.z "$dotfilesbackupdir"

echo -en "\n"
success "Backup completed to $HOME/backup/dotfiles-backup"
