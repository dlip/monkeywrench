#!/bin/bash
set -e

DOCKERFILES=( base aws ssh ansible ansibleaws terraform )

for DOCKERFILE in "${DOCKERFILES[@]}"; do
  echo "Building $DOCKERFILE..."
  docker build -f $DOCKERFILE.Dockerfile -t dlip/monkeywrench-$DOCKERFILE .
done
