# Git LFS

LFS is "Large File Storage" an extension for git that keeps large files outside of the actual repository so it doesn't become slow.

## Issues

> ⚠️ This repository is configured for Git LFS but 'git-lfs' was not found on your path. If you no longer wish to use Git LFS, remove this hook by deleting the 'post-checkout' file in the hooks directory (set by 'core.hookspath'; usually '.git/hooks'). Ref: [stackoverflow](https://stackoverflow.com/a/76403993)

When you run `git lfs install` it configures all the repositories to use `git lfs`. Instead, you can configure `git lfs` to use for specific repositories only.

```sh
git lfs uninstall

Hooks for this repository have been removed.
Global Git LFS configuration has been removed.
```

```sh
cd to_the_repo_of_choice
git lfs install --local
# This will enable git lfs only for particular repository.
```
