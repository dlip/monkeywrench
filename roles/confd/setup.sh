#!/bin/bash

echo_log "Running confd environment templates"
confd -onetime -backend env
