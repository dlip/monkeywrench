#!/bin/bash
SCRIPT_NAME=`readlink -f ${BASH_SOURCE[0]}`
DIR="$( cd "$( dirname "${SCRIPT_NAME}" )" && pwd )"

function find-up () {
  path=$(pwd)
  while [[ "$path" != "" && ! -f "$path/$1" ]]; do
    path=${path%/*}
  done
  echo "$path"
}

function help {
  echo "USAGE: ${0} <platform> <environment> <container> [arguments]"
  exit 1
}
# All of the args are mandatory.
if [ $# -lt 3 ]; then
  echo "ERROR: Not enough arguments"
  help
fi

PLATFORM=$1
ENVIRONMENT=$2
TOOL=$3
DOCKER_VARS=""

# This makes develoment easier when editing scripts
if [ -n "$MW_DEVMODE" ]; then
  echo "Running in dev mode"
  DOCKER_VARS=" -v $DIR/roles:/roles --link etcd "
fi


declare -a ENV_FILES=(
  env
  env.private
  envpe.${PLATFORM}-${ENVIRONMENT}
  envpe.${PLATFORM}-${ENVIRONMENT}.private
)

for ENV_FILE in ${ENV_FILES[@]}; do
  ENV_LOCATION=$(find-up $ENV_FILE)
  if [ -n "$ENV_LOCATION" ]; then
    echo "Found env file at $ENV_LOCATION/$ENV_FILE"
    DOCKER_VARS="$DOCKER_VARS -v $ENV_LOCATION/$ENV_FILE:/local_environment/$ENV_FILE"
  fi
done

echo "--- Start Container ---"
docker run --rm -it\
  $DOCKER_VARS\
  -e PLATFORM=$PLATFORM\
  -e ENVIRONMENT=$ENVIRONMENT\
  -v "$PWD:/mnt/workdir"\
  dlip/monkeywrench-$TOOL "${@:4}"
