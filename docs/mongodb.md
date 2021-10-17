# mongodb

> The mongodb homebrew official tap is available [here](https://github.com/mongodb/homebrew-brew).

## Up and Running

### Run `mongod` as a service

To have launchd start and stop `mongod` immediately and also restart at login, use:

```sh
> brew services start mongodb-community
> brew services stop mongodb-community
```

If you don't want/need a background service you can just run:

> The MongoDB server does not have a default configuration file or log directory path and will use a data directory path of `/data/db`

```sh
> mongod --config /usr/local/etc/mongod.conf
> mongo admin --eval "db.shutdownServer()" # to shutdown
```

## Uninstalling the mongodb-community Server

```sh
> brew uninstall mongodb-community
> brew uninstall mongodb-database-tools
> brew uninstall --cask mongodb-compass
```
