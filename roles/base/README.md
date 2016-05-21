# Base Role

## Variables

MW_PROXY_HOST
eg. 172.17.0.1

MW_PROXY_PROTOCOL
eg. http

MW_PROXY_PORT
eg. 3128

## Technical Details

### Roles

- Each role has an install.sh
- If there are remote environment scrips should symlink to /scripts/remote_environment/
- If there are setup scrips should symlink to /scripts/setup/
