# Docker Home Server

## nginx reverse proxy with letsencrypt companion

- custom nginx-proxy container with increased request body size
- creates a docker network `proxy`

### backup/restore

> reference : https://www.teosoft.it/post/2019-02-18-nextcloud-docker-backup-and-update/ [archive.org](https://web.archive.org/web/20210408185513/https://www.teosoft.it/post/2019-02-18-nextcloud-docker-backup-and-update/)

```bash
# backup
bash volume_backup.sh backup nextcloud_db
bash volume_backup.sh backup nextcloud_data
# restore
bash volume_backup.sh restore nextcloud_db nextcloud_db-xxx.tar
bash volume_backup.sh restore nextcloud_data nextcloud_data-xxx.tar
```

## Misc

### Orange specific

if your ISP is Orange, check that your livebox has the IP loopback option (https://assistance.orange.fr/livebox-modem/toutes-les-livebox-et-modems/installer-et-utiliser/piloter-et-parametrer-votre-materiel/le-parametrage-avance-reseau-nat-pat-ip/dns/livebox-4-le-loopback_243342-785338 [archive.org](https://web.archive.org/web/20210408185518/https://assistance.orange.fr/livebox-modem/toutes-les-livebox-et-modems/installer-et-utiliser/piloter-et-parametrer-votre-materiel/le-parametrage-avance-reseau-nat-pat-ip/dns/livebox-4-le-loopback_243342-785338))

required : livebox version >= 4

### OVH specific

if your ISP gives you a dynamic IP address, with a domain at OVH you can use `ddclient` to update your DNS.

- source : https://www.tombarbette.be/dynamic-dns-with-ovh/ ([archive.org](https://web.archive.org/web/20210408185458/https://www.tombarbette.be/dynamic-dns-with-ovh/))

### Docker compose guidelines example

- `.env` file

```bash
# NGINX + LETSENCRYPT
APP_DOMAIN=SERVICE.CHANGE_ME.COM

# APP
```

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
    env:
      # General
      - TZ=Europe/Paris
      # nginx + letsencrypt
      - VIRTUAL_PORT=80 # same as expose
      - VIRTUAL_HOST=${APP_DOMAIN}
      - LETSENCRYPT_HOST=${APP_DOMAIN}
      # app
    volumes:
      - unique_volume_name:/CHANGE_ME
    networks:
      - proxy
      - unique_network_name

volumes:
  unique_volume_name:
    name: unique_volume_name

networks:
  proxy:
    external: true
  unique_network_name:
    name: unique_network_name
```
