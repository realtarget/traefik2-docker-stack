#!/usr/bin/env bash

set -ex

for app in traefik2 portainer atlassian gitlab nexus rocketchat; do
  PATH="$PATH":/usr/local/bin docker-compose -f $app/docker-compose.yml down --remove-orphans
done
docker network rm traefik-proxy || true
