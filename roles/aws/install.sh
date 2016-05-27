#!/bin/bash
set -e
set -x

apt-get -y install python-pip jq

pip install boto awscli

mkdir -p /root/.aws

ln -s /roles/aws/setup.sh /scripts/setup/50-aws-setup.sh
