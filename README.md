
# My Docker Development Stack (traefik, gitlab, Jira, Confluence, Crowd, Rocketchat & Portainer)

Some days ago traefik released it's brand new Version 2 (RC1) including http and TCP routing (including SSH) - YAY! So i've rebuilt our docker development stack to consolidate all needed services from different machines on a new all-in-one docker server.

First of all: The documentation of traefik V2 is huge and detailed, but it's impossible to find any good tutorials or copy-and-paste examples to get things fast up and running. However, after many hours of reading the forums, searching github issues and drinking wine, i had all containers in production.

## traefik v2 Proxy

My configuration includes the following files:
* docker-compose.yml *for the docker container*
* traefik.toml *for general traefik configuration*
* provider_file.toml *to define a global accessible http to https redirect middleware*
* acme.json *for letsencrypt*

#### Lets Encrypt integration

It's important to 
```
sudo touch /var/acme.json
sudo chmod 600 /var/acme.json
```
for security purposes. The file can be left empty and will be automatically filled with the letsencrypt responses.

#### http-to-https redirect middleware

I use two entry points for each webservice. One for (unencrypted) http traffic and one for https. So we need to define a middleware in the docker labels for unencrypted port 80 acces.

```
# Entry point for http
- traefik.http.routers.traefik.entrypoints=web
# Listen domain 
- traefik.http.routers.traefik.rule=Host(`traefik.domain.com`)
# Use a middleware named "redirect" to forward the request to https (defined in provider_file.toml)
- traefik.http.routers.traefik.middlewares=redirect@file
```

Due to the fact that i want to reuse the middleware i've created a separate provider file which contains the configuration for the new scheme.

#### Example label for secure entrypoint to redirect the traefik dashboard

The docker-compose.yml includes necessary rules to access the traefik dashboard via traefic via https,

```
# secure entry point (port 443)
- traefik.http.routers.traefik_secure.entrypoints=web-secure
# Listen domain
- traefik.http.routers.traefik_secure.rule=Host(`traefik.domain.com`)
# Letsentrypt
- traefik.http.routers.traefik_secure.tls.certresolver=letsencrypt
# Port for traefik dashboard
- traefik.http.services.traefik.loadbalancer.server.port=8080
```
Naming convention: I usually use the name of the app for the routers definition eg. traefik and add _secure for the secure entry point. Router names can only used once for all running docker services.

## Gitlab (https + SSH via traefik)

The main reason for switching to traefik v2 was that it supports hostname based tcp routing. All versions below only worked for web (http + https). Out old (dedicated and undockerized) gitlab server used port 22 for ssh access. With the new possibilities of traefic v2 we are able to run gitlab in a docker environment which is easier to maintain.

#### docker-compose.yml

First of all, define the ssh port in the gitlab environment variables so that all links in the "clone repository" section work:

    gitlab_rails['gitlab_shell_ssh_port'] = 2222

Define the docker port:

    ports:
    - "2222:22"

And the traefik labels:

    # define hostname for the gitlab-ssh router
    - traefik.tcp.routers.gitlab-ssh.rule=HostSNI(`gitlab.domain.com`)
    # define the ssh entry point
    - traefik.tcp.routers.gitlab-ssh.entrypoints=ssh
    # define service to use
    - traefik.tcp.routers.gitlab-ssh.service=gitlab-ssh-svc
    # define backend port to use
    - traefik.tcp.services.gitlab-ssh-svc.loadbalancer.server.port=2222

#### treafik.toml

If you want to access ssh on port 2222 you also need to add this as a new entry point in the traefik.toml:

    [entryPoints.ssh]
    address = ":2222"

#### Port 22 vs. 2222
If your servers ssh daemon listens on another port than 22 it's possible to use 22 for gitlab. Just change the port number to a port of your choice.

## Rocketchat
Configs are self-explaining if you take a look at the traefik and gitlab config.

## Atlassian Confluence, Jira Software + Crowd
Configs are self-explaining if you take a look at the traefik and gitlab config.

## Portainer
Configs are self-explaining if you take a look at the traefik and gitlab config.

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

