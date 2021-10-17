## db

### Ignore Zookeeper brew dependencies

```sh
# check all the dependencies except java
> brew list <package_name> || brew install <package_name>
> brew unlink zookeeper
> brew install zookeeper --ignore-dependencies # to ignore openjdk 15 dependency
```

```sh
> brew services start zookeeper # starts as background service
> zkServer start # Or, if you don't want/need a background service you can just run
```

### etcd

- key/value pair database

```sh
> brew install etcd
> etcd  # execute etcd to start the service
```

### ballerina

```sh
> brew install ballerina --ignore-dependencies
```
