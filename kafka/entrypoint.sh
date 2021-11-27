#!/bin/bash

set -exu

if [[ ! -f "/kafka/config/server.properties" ]]; then
  env | grep ^KPROP_ | awk -v FS='=' -v OFS='='  '{ k=tolower(substr($1, 7)); gsub(/_/, ".", k); print k, $2 }' >> /kafka/config/server.properties
fi

if [[ -f "/kafka/setup.sh" ]]; then
  /kafka/setup.sh
fi

exec "$@"
