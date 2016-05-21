#!/bin/bash
set -e

mkdir -p /root/.ssh

ln -s /roles/ssh/ssh_config.tmpl /etc/confd/templates/ssh_config.tmpl
ln -s /roles/ssh/ssh_config.toml /etc/confd/conf.d/ssh_config.toml
