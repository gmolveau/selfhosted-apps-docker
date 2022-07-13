#!/usr/bin/env bash

set -o errexit # set -e
set -o nounset # set -u
set -o pipefail

# check which "docker compose" flavour to use
DOCKERCOMPOSE="docker compose"
if ! command -v ${DOCKERCOMPOSE} &> /dev/null; then
    DOCKERCOMPOSE="docker-compose"
fi

apps=(
    #"bitwarden"
    "freshrss"
    "nextcloud-collabora"
    "nginx-static"
    #"nitter"
    "plexmediaserver"
    "transmission-openvpn"
    "wallabag"
    "wekan"
    # always put the proxy last
    "nginx-letsencrypt-proxy"
)

function up() {
    for app in "${apps[@]}"; do
        (
            cd "${app}" \
                && ${DOCKERCOMPOSE} pull \
                && ${DOCKERCOMPOSE} build --pull --force-rm --no-cache \
                && ${DOCKERCOMPOSE} up --force-recreate -d
        )
    done
    docker system prune -f
}

function down() {
    for app in "${apps[@]}"; do
        (
            cd "${app}" \
                && ${DOCKERCOMPOSE} down
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
