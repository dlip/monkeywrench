#!/bin/bash
set -e
set -x

yum -y install openssh-clients gcc make

# Corkscrew is used for SSHing through proxies
export CORKSCREW_VERSION=2.0
mkdir /tmp/corkscrew
cd /tmp/corkscrew
curl -OL http://agroman.net/corkscrew/corkscrew-${CORKSCREW_VERSION}.tar.gz
tar -zxf corkscrew-${CORKSCREW_VERSION}.tar.gz
cd corkscrew-${CORKSCREW_VERSION}
./configure
make install
rm -rf /tmp/corkscrew

mkdir -p /root/.ssh

ln -s /roles/ssh/ssh_config.tmpl /etc/confd/templates/ssh_config.tmpl
ln -s /roles/ssh/ssh_config.toml /etc/confd/conf.d/ssh_config.toml

ln -s /roles/ssh/setup.sh /scripts/setup/50-ssh-setup.sh
