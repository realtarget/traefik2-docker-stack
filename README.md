# Our Docker Development Stack

Some days ago traefik released it's brand new Version 2 (RC1) including http and TCP routing including SSH - YAY! So i've rebuilt our docker development stack to consolidate all needed services on a new docker server.

First of all: The documentation of traefik V2 is huge and detailed, but it's  impossible to find any good tutorials or copy-and-paste exampeles. However, after many hours of reading the forums, github issues and bottles of wine, i had all up and running.

## traefik Proxy

The configuration includes the following files:
* docker-compose.yml (for the docker container)
* traefik.toml (for general configuration)
* provider_file.toml (to define the http to https redirect for all web services)
* acme.json (for letsencrypt)

It's important to 

`sudo touch /var/acme.json`

and

`sudo chmod 600 /var/acme.json`

for security purposes. acme.json can be left empty and will be filled by letsencrypt challenge responses.

The docker-compose.yml includes necessary rules to access the traefik dashboard via traefic via https.

Due to the fact that i want to route al http traffic to https i've created a separate file provider which configuration is in a separate file.

By adding

`- traefik.http.routers.gitlab_insecure.middlewares=redirect@file`

to the docker-compose.yml traefic uses my redirect rule to the https scheme.

## Gitlab (https + SSH via traefik)

## Rocketchat

## Atlassian Confluence, Jira Software + Crowd

## Portainer

## Server Specs
### Hardware
* Intel Haswell i5-4590 (quad-core, up to 4x 3,7 GHz
* 32 GB DDR3 RAM
* 2x 500GB SSD
* 1 Gbit/s Uplink
### Software 
* Ubuntu 18.04 LTS
* Docker 18.09.7
* docker-compose version 1.25.0-rc2
