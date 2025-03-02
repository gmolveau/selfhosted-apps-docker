#!/usr/bin/env bash

set -o errexit # set -e
set -o nounset # set -u
set -o pipefail

UP_APPS=(
    "nginx-letsencrypt-proxy" # nginx proxy is required by all
    "filebrowser"
    "freshrss"
    "gluetun" # gluetun is required by transmission
    "transmission"
    "h5ai"
    "it-tools"
    "nextcloud-collabora"
    "nginx-static"
    "plexmediaserver"
    "stirling-pdf"
    "wallabag"
)

function up() {
    for app in "${UP_APPS[@]}"; do
        (
            cd "${app}" \
                && docker compose pull \
                && docker compose build --pull --force-rm --no-cache \
                && docker compose up --build --force-recreate -d
        )
    done
    docker system prune -f
}

DOWN_APPS=(
    "filebrowser"
    "freshrss"
    "transmission" # transmission depends_on gluetun
    "gluetun"
    "h5ai"
    "it-tools"
    "nextcloud-collabora"
    "nginx-static"
    "plexmediaserver"
    "stirling-pdf"
    "wallabag"
    # nginx proxy in last
    "nginx-letsencrypt-proxy"
)

function down() {
    for app in "${DOWN_APPS[@]}"; do
        (
            cd "${app}" \
                && docker compose down
        )
    done
    docker system prune -f
}

function print_usage() {
    echo "Usage :"
    echo "    $0 up"
    echo "    $0 stop"
}

if (($# < 1)); then
    print_usage
    exit 1
fi

case "$1" in
    "up")
        shift
        up "$@"
        ;;
    "down")
        shift
        down "$@"
        ;;
    *)
        echo "unknown command"
        print_usage
        exit 1
        ;;
esac

exit 0
