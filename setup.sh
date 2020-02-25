#!/usr/bin/env bash

set -ex

docker network create --driver overlay traefik-proxy >/dev/null 2>&1 || true
for app in traefik2 metrics portainer dbadmin atlassian gitlab nexus rocketchat; do
   docker stack deploy --compose-file $app/docker-compose.yml devops
done
