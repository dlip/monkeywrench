#!/bin/bash
set -e

DOCKERFILES=( base aws ssh ansible ansibleaws terraform )

for DOCKERFILE in "${DOCKERFILES[@]}"; do
  echo "Pushing $DOCKERFILE..."
  docker tag monkeywrench-$DOCKERFILE dlip/monkeywrench-$DOCKERFILE
  docker push dlip/monkeywrench-$DOCKERFILE
done
