# Our Docker Development Stack

Some days ago traefik released it's brand new Version 2 (RC1) including http and TCP routing including SSH - YAY! So i've rebuilt our docker development stack to consolidate all needed services on a new docker server.

First of all: The documentation of traefik V2 is huge and detailed, but it's impossible to find any good tutorials or copy-and-paste examples. However, after many hours of reading the forums, searching github issues and drinking wine, i had all up and running.

## traefik Proxy

My configuration includes the following files:
* docker-compose.yml (for the docker container)
* traefik.toml (for general configuration)
* provider_file.toml (to define a global accessible http to https redirect)
* acme.json (for letsencrypt)

#### Lets Encrypt integration

It's important to 
```
sudo touch /var/acme.json
sudo chmod 600 /var/acme.json
```
for security purposes. acme.json can be left empty and will be automatically filled with the letsencrypt responses.

#### Permanent https redirect

I use two entry points for each webservice. One for (unencrypted) http traffic and one for https.

```
# Entry point for http
- traefik.http.routers.traefik.entrypoints=web
# Listen domain 
- traefik.http.routers.traefik.rule=Host(`traefik.domain.com`)
# Use a middleware named "redirect" to forward the request to https
- traefik.http.routers.traefik.middlewares=redirect@file
```

Due to the fact that i want to redirect all http traffic to https i've created a separate provider file which contains the configuration for the redirect@file middleware.

#### Rules for traefik dashboard

The docker-compose.yml includes necessary rules to access the traefik dashboard via traefic via https

```
# secure entry point (port 443)
- traefik.http.routers.traefik_secure.entrypoints=web-secure
# Listen domain
- traefik.http.routers.traefik_secure.rule=Host(`traefik.domain.com`)
# Letsentrypt
- traefik.http.routers.traefik_secure.tls.certresolver=letsencrypt
# Port for traefik dashboard
- traefik.http.services.traefik.loadbalancer.server.port=8080
# External network to use
- traefik.docker.network=traefik-proxy
```

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
