# Monkeywrench (WIP)
 
Monkeywrench is a set of docker containers with tools to make devops life easier. All tools can get the config they need from environment variables and remote key value stores such as vault using confd.

# Requirements

* docker

## Setup

```
./build.sh
sudo ln -s $(pwd)/monkeywrench.sh /usr/bin/mw
```

- Create local environment files, it will search up directories for the following files:

- env
- env.private
- envpe.${PLATFORM}-${ENVIRONMENT}
- envpe.${PLATFORM}-${ENVIRONMENT}.private

- Find out more valid variables in the roles doc
- Some roles can also download remote environment variables also

## Roles

- [base](roles/base/README.md)
- [confd](roles/base/README.md)
- [ssh](roles/ssh/README.md)
- [ansible](roles/ansible/README.md)

## Usage

- The command line arguments are `mw <platform> <environment> <container> <command> [arguments]`

```
mv projectx nonprod ansible ansible-playbook myplaybook.yml
```

