#!/usr/bin/env bash

set -ex

docker stack rm devops
docker network rm traefik-proxy >/dev/null 2>&1 || true
