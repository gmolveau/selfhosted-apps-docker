#!/usr/bin/env bash

set -o errexit # set -e
set -o nounset # set -u
set -o pipefail

apps=(
    #"bitwarden"
    "freshrss"
    "nextcloud-collabora"
    "nginx-static"
    #"nitter"
    "wallabag"
    "wekan"
    # always put the proxy last
    "nginx-letsencrypt-proxy"
)

function update() {
    for app in "${apps[@]}"; do
        (
            cd "${app}" \
                && docker-compose pull \
                && docker-compose up --build -d
        )
    done
    docker system prune -f
}

function stop() {
    for app in "${apps[@]}"; do
        (
            cd "${app}" \
                && docker-compose down
        )
    done
    docker system prune -f
}

function print_usage() {
    echo "Usage :"
    echo "    manage.sh update"
    echo "    manage.sh stop"
}

if (($# < 1)); then
    print_usage
    exit 1
fi

case "$1" in
    "update")
        shift
        update "$@"
        ;;
    "stop")
        shift
        stop "$@"
        ;;
    *)
        echo "unknown command"
        print_usage
        exit 1
        ;;
esac

exit 0
