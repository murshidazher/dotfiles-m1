# ssh config file

- Read this for [multiple account setup](https://stackoverflow.com/questions/2419566/best-way-to-use-multiple-ssh-private-keys-on-one-client)
- Read this for [bitbucket key generation](https://support.atlassian.com/bitbucket-cloud/docs/set-up-an-ssh-key/)

## Template

```sh
Host *
  IgnoreUnknown AddKeysToAgent
  AddKeysToAgent yes
  ForwardX11 no
  ForwardAgent yes

# github
Host github.com
  User murshidazher
  HostName github.com
  IdentityFile ~/.ssh/id_rsa
  PreferredAuthentications publickey
  IdentitiesOnly yes

# bitbucket
Host bitbucket.org
  HostName bitbucket.org
  IdentityFile ~/.ssh/id_bitbucket_rsa
  PreferredAuthentications publickey
  IdentitiesOnly yes

# personal
Host personal
  HostName github.com
  IdentityFile ~/.ssh/id_rsa
  PreferredAuthentications publickey
  IdentitiesOnly yes

# company
Host company
  HostName github.com
  IdentityFile ~/.ssh/id_rsa
  PreferredAuthentications publickey
  IdentitiesOnly yes

# hirw
Host hirw
  User hirwuserxxxx
  HostName xx.xx.xxx.xxx
  IdentityFile ~/.ssh/hirwuserxxxx.pem
  Port 22
```

### LICENSE

MIT
