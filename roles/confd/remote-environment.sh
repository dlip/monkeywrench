#!/bin/bash

ENVIRONMENT_CONFDIR=/roles/confd/environment

if [ -n "$MW_CONFD_ETCD_HOST" ]; then
  echo_log "Running confd etcd config"
  confd -onetime -backend etcd -node $MW_CONFD_ETCD_HOST -confdir="$ENVIRONMENT_CONFDIR/etcd" -prefix "/$PLATFORM/$ENVIRONMENT"
else
  echo_warning "Skipping confd etcd config"
fi
