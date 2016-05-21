#!/bin/bash
set -e
set -x

yum -y install python-setuptools python-pip jq
yum clean all

pip install boto awscli

mkdir -p /root/.aws

ln -s /roles/aws/setup.sh /scripts/setup/50-aws-setup.sh
