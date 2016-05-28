# Confd role

[Confd](https://github.com/kelseyhightower/confd) is a core part of all the tools in Monkeywrench. It has backends for reading environment from many sources and also includes the golang templating language for creating configuration files.

## Remote Environment

### etcd

Will look in the prefix /${PLATFORM}/${ENVIRONMENT}. Note: it is only designed to work if the variables are all flat (not nested) for converting to environment variables

- MW_CONFD_ETCD_HOST
  - The url of the etcd service
  - eg. http://etcd:4001

### consul

TODO

### dynamodb

TODO

### rancher

TODO

### redis

TODO

### stackengine

TODO

### vault

TODO

### zookeeper

TODO

## Templating

Golang templates will be read from /etc/confd which will be setup in the containers role by the developer.
