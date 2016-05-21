#!/bin/bash
set -e
set -x

yum -y install python-setuptools python-pip jq
yum clean all

pip install boto awscli

mkdir -p /root/.aws

ln -s /roles/aws/aws_config.tmpl /etc/confd/templates/aws_config.tmpl
ln -s /roles/aws/aws_config.toml /etc/confd/conf.d/aws_config.toml

ln -s /roles/aws/aws_credentials.tmpl /etc/confd/templates/aws_credentials.tmpl
ln -s /roles/aws/aws_credentials.toml /etc/confd/conf.d/aws_credentials.toml

ln -s /roles/aws/setup.sh /scripts/setup/50-aws-setup.sh
