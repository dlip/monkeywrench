#!/bin/bash
set -e

DOCKERFILES=( base aws ssh ansible ansibleaws terraform )

for DOCKERFILE in "${DOCKERFILES[@]}"; do
  echo "Building $DOCKERFILE..."
  docker build -f monkeywrench-$DOCKERFILE.Dockerfile -t monkeywrench-$DOCKERFILE .
done
