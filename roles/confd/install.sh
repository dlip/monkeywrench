#!/bin/bash
set -e
set -x

CONFD_VERSION=0.11.0
cd /tmp
curl -OL https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64
chmod +x confd-$CONFD_VERSION-linux-amd64
mv confd-$CONFD_VERSION-linux-amd64 /usr/bin/confd

mkdir -p /etc/confd/{conf.d,templates}

ln -s /roles/confd/remote-environment.sh /scripts/remote_environment/10-confd-remote_environment.sh

ln -s /roles/confd/setup.sh /scripts/setup/10-confd-setup.sh
