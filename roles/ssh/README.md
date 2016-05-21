# SSH Role

## Variables

B64_SSH_PRIVATE_KEY
Base64 encoded ssh key `cat ~/.ssh/my_private_key | base64 -w0`

MW_BASTION_HOST
eg. bastion.mydomain.com

MW_BASTION_USER
eg. ubuntu

MW_BASTION_SUBNETS
eg. 10.10.123.*,10.10.456.*

Also uses proxy settings from base role
