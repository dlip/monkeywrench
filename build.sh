#!/bin/bash
set -e

DOCKERFILES=( base ansible ssh terraform )

for DOCKERFILE in "${DOCKERFILES[@]}"; do
  echo "Building $DOCKERFILE..."
  docker build -f monkeywrench-$DOCKERFILE.Dockerfile -t monkeywrench-$DOCKERFILE .
done
