#!/usr/bin/env bash

set -o errexit # set -e
set -o nounset # set -u
set -o pipefail

apps=(
    "bitwarden"
    "freshrss"
    "nextcloud-collabora"
    "nginx-letsencrypt-proxy"
    "nginx-static"
    "nitter"
    "wallabag"
    "wekan"
)

for app in "${apps[@]}"; do
    ( cd "${app}" && docker-compose pull && docker-compose up --build -d )
done

# docker system prune --volumes -f
docker system prune -f