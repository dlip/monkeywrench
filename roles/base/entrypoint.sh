#!/bin/bash

source /roles/base/util.sh

if [ ! "$(ls -A /local_environment)" ]
then
  echo_warning "No local environment files found"
else
  echo_log "Loading local environment files"
  for FILE in `ls -1 /local_environment`; do
    echo_log "Loading local environment from $FILE"
    set -a
    source "/local_environment/$FILE"
    set +a
  done
fi


declare -a REQURIED_ENV=(
  ENVIRONMENT
  PLATFORM
)

for var in ${REQURIED_ENV[@]}; do
    if [ -z "${!var}" ] ; then
        echo_warning "ERROR: Environment variable '$var' is not set"
        exit 1
    fi
done

if [ -z "$MW_PROXY_HOST" ]; then
  echo_warning "No proxy set"
  unset http_proxy
  unset https_proxy
else
  echo_log "Setting proxy to $MW_PROXY_PROTOCOL://$MW_PROXY_HOST:$MW_PROXY_PORT"
  export http_proxy=$MW_PROXY_PROTOCOL://$MW_PROXY_HOST:$MW_PROXY_PORT
  export https_proxy=$MW_PROXY_PROTOCOL://$MW_PROXY_HOST:$MW_PROXY_PORT
fi

if [ ! "$(ls -A /scripts/remote_environment)" ]
then
  echo_warning "No remote environment scripts found"
else
  echo_log "Running remote environment scripts"
  for FILE in `ls -1 /scripts/remote_environment`; do
    echo_log "Running $FILE"
    source /scripts/remote_environment/$FILE
  done
fi

if [ ! "$(ls -A /remote_environment)" ]
then
  echo_warning "No remote environment files found"
else
  echo_log "Loading remote environment files"
  set -a
  for FILE in `ls -1 /remote_environment`; do
    echo_log "Loading remote environment from $FILE"
    source "/remote_environment/$FILE"
  done
  set +a
fi

if [ ! "$(ls -A /scripts/setup)" ]
then
  echo_warning "No setup scripts found"
else
  echo_log "Running setup scripts"
  for FILE in `ls -1 /scripts/setup`; do
    echo_log "Running $FILE"
    source /scripts/setup/$FILE
  done
fi

echo_log "Running command ${@}"
exec "${@}"
