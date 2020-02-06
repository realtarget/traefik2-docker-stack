#!/usr/bin/env bash

set -ex

docker network create traefik-proxy || true
for app in traefik2 portainer atlassian gitlab nexus rocketchat; do
  docker-compose -f $app/docker-compose.yml up -d
done
