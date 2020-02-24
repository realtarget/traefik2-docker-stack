#!/usr/bin/env bash

set -ex

docker stack rm dev_ops
docker network rm traefik-proxy || true
