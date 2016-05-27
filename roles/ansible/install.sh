#!/bin/bash
set -e
set -x

apt-get install -y python-yaml python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools python-pkg-resources python-pip
ANSIBLE_VERSION=2.0.2.0

pip install ansible==$ANSIBLE_VERSION
