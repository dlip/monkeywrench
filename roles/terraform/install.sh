#!/bin/bash
set -e
set -x

apt-get install -y unzip

TERRAFORM_VERSION=0.6.16
mkdir /tmp/terraform
cd /tmp/terraform
curl -OL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
mv * /usr/local/bin
chmod +x /usr/local/bin/terraform
rm -rf /tmp/terraform
