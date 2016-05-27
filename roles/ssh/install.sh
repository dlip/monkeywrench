#!/bin/bash
set -e
set -x

apt-get install -y ssh corkscrew

mkdir -p /root/.ssh

ln -s /roles/ssh/ssh_config.tmpl /etc/confd/templates/ssh_config.tmpl
ln -s /roles/ssh/ssh_config.toml /etc/confd/conf.d/ssh_config.toml

ln -s /roles/ssh/setup.sh /scripts/setup/50-ssh-setup.sh
