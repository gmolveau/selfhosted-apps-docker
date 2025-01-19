# Docker Home Server

## nginx reverse proxy with letsencrypt companion

- reverse-proxy : <https://github.com/nginx-proxy/nginx-proxy/>
- custom nginx-proxy container with increased request body size
- with a dedicated docker network `proxy`

## Docker compose guidelines example

- `.env` file

```bash
# NGINX + LETSENCRYPT
APP_DOMAIN=SERVICE.CHANGE_ME.COM

# APP
```

- create a `./volumes/CHANGE_ME/.gitkeep` file for each local volume required

- `docker-compose.yml` file

```yml
version: '3.5'

services:
  unique_service_name:
    container_name: unique_service_name
    hostname: unique_service_name
    restart: on-failure:5
    expose:
      - 80
    environment:
      # general
      - TZ=Europe/Paris
      # nginx + letsencrypt
      - VIRTUAL_PORT=80 # same as expose
      - VIRTUAL_HOST=${APP_DOMAIN}
      - LETSENCRYPT_HOST=${APP_DOMAIN}
      # app
    volumes:
      - ./volumes/CHANGE_ME:/CHANGE_ME
    networks:
      - proxy
      - unique_network_name # if necessary

networks:
  proxy:
    external: true
  unique_network_name:
    name: unique_network_name
```

## Misc

### Orange specific

if your ISP is Orange, check that your livebox has the IP loopback option (https://assistance.orange.fr/livebox-modem/toutes-les-livebox-et-modems/installer-et-utiliser/piloter-et-parametrer-votre-materiel/le-parametrage-avance-reseau-nat-pat-ip/dns/livebox-4-le-loopback_243342-785338 [archive.org](https://web.archive.org/web/20210408185518/https://assistance.orange.fr/livebox-modem/toutes-les-livebox-et-modems/installer-et-utiliser/piloter-et-parametrer-votre-materiel/le-parametrage-avance-reseau-nat-pat-ip/dns/livebox-4-le-loopback_243342-785338))

required : livebox version >= 4

### OVH specific

if your ISP gives you a dynamic IP address, with a domain at OVH you can use `ddclient` to update your DNS.

- source : https://www.tombarbette.be/dynamic-dns-with-ovh/ ([archive.org](https://web.archive.org/web/20210408185458/https://www.tombarbette.be/dynamic-dns-with-ovh/))
