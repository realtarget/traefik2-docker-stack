#!/usr/bin/env bash

set -ex

docker network create traefik-proxy
PATH="$PATH":/usr/local/bin docker-compose -f atlassian/docker-compose.yml -f gitlab/docker-compose.yml -f nexus/docker-compose.yml -f portainer/docker-compose.yml -f rocketchat/docker-compose.yml -f traefik2/docker-compose.yml up -d

