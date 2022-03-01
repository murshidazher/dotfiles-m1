#!/usr/bin/env bash
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  # shellcheck source=setup/lib.sh
  source ./setup/lib.sh
fi

# Load dirs and files if not already loaded.
if [ -z ${filesloaded+x} ]; then
  # shellcheck source=setup/files.sh
  source ./files.sh
  echo -en "\n"
fi

# Set dotfilesdir var if not declared.
if [ -z ${dotfilesdir+x} ]; then
  dotfilesdir="$HOME/${PWD##*/}"
fi

# Set defaultdotfilesdir var if not declared.
if [ -z ${defaultdotfilesdir+x} ]; then
  defaultdotfilesdir="$HOME/dotfiles"
fi

# Used later if we need to symlink to "$HOME/dotfiles"
linkdotfilesdir=false
linkdotfilesdirerror=false

bot "Create symlinks for directories and files."

action "Creating directory symlinks."
echo "dotfilesdir $dotfilesdir defaultdotfilesdir $defaultdotfilesdir"
# Symlink directories
for i in "${dotfilesdirarray[@]}"; do
  # symlink, targetting from $dotfilesdir to $HOME
  process_symlinks "$i" "$dotfilesdir" "$HOME"
done

action "Creating file symlinks."
# Loop dotfiles directories with files, symlink them.
for i in "${dotfilesfilearray[@]}"; do
  declare -a tmparr=()

  # Properly store the results of find on these directories in an array
  # We want to handle .*, *.cfg, *.conf and NOT .DS_Store, .git, .osx, .macos and no *.sh files
  while IFS= read -r -d $'\0'; do
    tmparr+=("$REPLY")
  done < <(find "$i" -type f -maxdepth 1 \( -name ".*" -o -name "*.cfg" -o -name "*.conf" \) -a -not -name .DS_Store -not -name .git -not -name .osx -not -name .macos -not -name "*.sh" -print0)

  for j in "${tmparr[@]}"; do
    # Symlink, targetting from $i (parent folder of dotfile group) to $HOME
    process_symlinks "$j" "$i" "$HOME"
  done
done

# Custom symlinks.
action "Creating custom symlinks."
# git-friendly symlinks
process_symlinks "$dotfilesdir/bin/git-friendly/branch" "$dotfilesdir/bin/git-friendly" "$dotfilesdir/bin"
process_symlinks "$dotfilesdir/bin/git-friendly/merge" "$dotfilesdir/bin/git-friendly" "$dotfilesdir/bin"
process_symlinks "$dotfilesdir/bin/git-friendly/pull" "$dotfilesdir/bin/git-friendly" "$dotfilesdir/bin"
process_symlinks "$dotfilesdir/bin/git-friendly/push" "$dotfilesdir/bin/git-friendly" "$dotfilesdir/bin"

# create custom vscode symlinks
process_symlinks "settings.json" "$dotfilesdir/vscode" "$HOME/Library/Application Support/Code/User"
process_symlinks "projects.json" "$dotfilesdir/vscode" "$HOME/Library/Application Support/Code/User"
process_symlinks "keybindings.json" "$dotfilesdir/vscode" "$HOME/Library/Application Support/Code/User"

# link the extensions
process_symlinks "extensions.json" "$dotfilesdir/vscode" "$defaultdotfilesdir/vscode"

# link the snippets folder
# process_symlinks "$dotfilesdir/vscode/snippets" "$dotfilesdir/vscode" "$HOME/Library/Application Support/Code/User/snippets"

# If files are not stored in ~/dotfiles then symlink to that folder
# note: if ~/dotfiles does exist or links elsewhere it only breaks
# the alias `dotfiles` and export $DOTFILES.
if ! [[ $defaultdotfilesdir -ef "$(pwd)" ]]; then
  action "Symlinking dotfiles dir to $defaultdotfilesdir"

  if [ -e "$defaultdotfilesdir" ]; then
    is_not_ci && ask_for_confirmation "\n'$defaultdotfilesdir' already exists, do you want to overwrite it?"

    if answer_is_yes || is_ci; then
      if [ -L "$defaultdotfilesdir" ]; then
        # Target is a link, unlink it.
        unlink "$defaultdotfilesdir"

        # Mark to symlink to default dotfiles dir location.
        linkdotfilesdir=true
      else
        is_not_ci && ask_for_confirmation "\n'$defaultdotfilesdir' is a directory, unlinking will delete all files in this directory -- ARE YOU SURE?"

        if answer_is_yes || is_ci; then
          # Target is a dir or file, trash or rm it.
          if hash trash 2>/dev/null; then
            # Prefer trash if installed, means we can restore.
            trash "$defaultdotfilesdir"
          else
            # rm = bye bye.
            rm -rf "$defaultdotfilesdir"
          fi

          # Flag to symlink to default dotfiles dir location.
          linkdotfilesdir=true
        else
          # Feedback to user that we couldn't symlink.
          linkdotfilesdirerror=true
        fi
      fi
    else
      # Feedback to user that we couldn't symlink.
      linkdotfilesdirerror=true
    fi
  else
    # Flag to symlink to default dotfiles dir location.
    linkdotfilesdir=true
  fi
fi

# Symlink to "$HOME/dotfiles" if required.
if $linkdotfilesdir; then
  ln -s "$dotfilesdir" "$defaultdotfilesdir"
fi

# Report error symlinking to "$HOME/dotfiles" if required.
if $linkdotfilesdirerror; then
  error "Could not symlink to $defaultdotfilesdir -- this means the commands 'df', 'dotfiles' and export '\$DOTFILES_DIR' will not point to $dotfilesdir correctly."
fi

echo -e "\n"
success "Processed symlinks.\n"
