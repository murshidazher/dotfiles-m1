# Kubernetes

- A list of commands which will help proceeding kubernetes easier.

## kubernetes-cli

- You may see this error after installed Kubernetes and run `brew doctor`.

```sh
# Warning: You have unlinked kegs in your Cellar.
# Leaving kegs unlinked can lead to build-trouble and cause brews that depend on
# those kegs to fail to run properly once built. Run `brew link` on these:
# kubernetes-cli

> rm /usr/local/bin/kubectl
> brew link --overwrite kubernetes-cli
```
