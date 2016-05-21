#!/bin/bash
set -e

echo_log "Running confd environment templates"
confd -onetime -backend env
