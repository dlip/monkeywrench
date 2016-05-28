# Monkeywrench

## Overview

Monkeywrench is a collection docker containers for devops tools. It aims to unify all the tools configuration, which can come from local and remote sources. It does this by gathering these various sources into environment variables, which can be easily read by many tools directly and otherwise used in templates to generate configuration files.

## Installation

- Install [docker](https://docs.docker.com/engine/installation/)

```
sudo curl -Lo /usr/local/bin/mw https://raw.githubusercontent.com/dlip/monkeywrench/master/monkeywrench.sh && sudo chmod +x /usr/local/bin/mw
```

## Configuration

Configuration comes from "local environment" and "remote environment". Local environment is read before remote environment so it can be used when requesting remote environment.

### Local Environment

Local environment comes from files either in the directory Monkeywrech is run from, or in directories above. The files are formatted `KEY=value` ie: 

```
DOMAIN=mydomain.com
DEPLOY_BRANCH=master
```

Interpolation and bash logic can also be used ie:

```
SITE_DOMAIN="myapp.${DOMAIN}"

if [[ "$DEPLOY_BRANCH" == "master" ]]; then
  SITE_WARNING="Site running in dev mode"
fi
```

The filenames are separated into "platform" and "environment" to allow working with different projects and deployments. The filenames are loaded in the following priority:

- env
- env.private
- envpe.${PLATFORM}-${ENVIRONMENT}
- envpe.${PLATFORM}-${ENVIRONMENT}.private

### Remote Environment

Each container has different roles installed which can load remote environment. You can read about it in the links for each container.

## Containers

- [Base](https://github.com/dlip/monkeywrench/blob/master/docs/base.md)
- [Ansible](https://github.com/dlip/monkeywrench/blob/master/docs/ansible.md)
- [AWS](https://github.com/dlip/monkeywrench/blob/master/docs/aws.md)
- [SSH](https://github.com/dlip/monkeywrench/blob/master/docs/ssh.md)
- [Terraform](https://github.com/dlip/monkeywrench/blob/master/docs/terraform.md)

## Usage

Pull the container you would like to run with the command `mw pull <container>` eg.

```
mv pull ansible
```

The command line arguments are `mw <platform> <environment> <container> <command> [arguments]` eg.

```
mv projectx nonprod ansible ansible-playbook myplaybook.yml
```

## Develoment

```
git clone https://github.com/dlip/monkeywrench.git
cd monkeywrench
./build.sh
sudo ln -s $(pwd)/monkeywrench.sh /usr/bin/mwd
```


