#!/bin/bash

SSH_PRIVATE_KEY_FILE=/root/.ssh/id_rsa_private

echo $B64_SSH_PRIVATE_KEY | base64 -d  > $SSH_PRIVATE_KEY_FILE
chmod 600 $SSH_PRIVATE_KEY_FILE

eval `ssh-agent -s`
ssh-add $SSH_PRIVATE_KEY_FILE
