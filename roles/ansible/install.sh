#!/bin/bash
set -e

yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip
yum clean all

ANSIBLE_VERSION=2.0.2.0

pip install ansible==$ANSIBLE_VERSION
