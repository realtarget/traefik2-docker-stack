#!/usr/bin/env bash

set -ex

docker network create --driver overlay traefik-proxy || true
for app in traefik2 metrics portainer atlassian gitlab nexus rocketchat; do
   docker stack deploy --compose-file $app/docker-compose.yml dev_ops
done
