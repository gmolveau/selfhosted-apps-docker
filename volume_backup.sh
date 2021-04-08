#!/usr/bin/env bash

# install : 
# sudo cp volume_backup.sh /usr/bin/volume_backup && sudo chmod +x /usr/bin/volume_backup

set -o errexit # set -e
set -o nounset # set -u
set -o pipefail

# references : 
# - https://medium.com/@loomchild/backup-restore-docker-named-volumes-350397b8e362 (https://web.archive.org/web/20210408185936/https://jareklipski.medium.com/backup-restore-docker-named-volumes-350397b8e362)
# - https://blog.ssdnodes.com/blog/docker-backup-volumes/ (https://web.archive.org/web/20210408185924/https://blog.ssdnodes.com/blog/docker-backup-volumes/)

function backup() {

  if (( $# < 2 )); then
    echo "error : missing volume name and/or destination path argument(s)"
    exit 1
  fi

  VOLUME_NAME=$1

  volume_exists "$VOLUME_NAME" || {
    echo "error : volume '$VOLUME_NAME' does not exist"
    exit 1
  }

  BACKUP_PATH=$2
  if [ $(dirname $BACKUP_PATH) == "." ]; then
    BACKUP_PATH=$(pwd)
  fi
  mkdir -p "$BACKUP_PATH"

  TIMESTAMP=$(date -u +"%Y%m%dT%H%M%S")
  BACKUP_NAME="$VOLUME_NAME-$TIMESTAMP.tar"

  echo "backing up volume '$VOLUME_NAME' to '$BACKUP_PATH/$BACKUP_NAME' ..."
  # tar without the full path : https://stackoverflow.com/a/18681628
  docker run --rm -v "$VOLUME_NAME":/volume -v "$BACKUP_PATH":/backup alpine tar -cf /backup/"$BACKUP_NAME" -C /volume ./
  if [ $? -eq 0 ]; then
    echo "success !"
  else
    echo "error :<"
  fi

}

function restore() {

  if (( $# < 2 )); then
    echo "error : missing volume name and/or backup name argument(s)"
    exit 1
  fi

  VOLUME_NAME=$1
  volume_exists "$VOLUME_NAME" || {
    echo "error : volume '$VOLUME_NAME' does not exist"
    echo "you can create it with this command : docker volume create $VOLUME_NAME"
    exit 1
  }

  BACKUP_PATH=$2
  if [ ! -f "$BACKUP_PATH" ]; then
    echo "error : backup '$BACKUP_PATH' does not exist"
    exit 1
  fi

  BACKUP_NAME="$(basename $BACKUP_PATH)"
  BACKUP_PATH="$(dirname $BACKUP_PATH)"
  if [ $(dirname $BACKUP_PATH) == "." ]; then
    BACKUP_PATH=$(pwd)
  fi
  
  echo "restoring volume '$VOLUME_NAME' from '$BACKUP_PATH/$BACKUP_NAME' ..."
  docker run --rm -v "$VOLUME_NAME":/volume -v "$BACKUP_PATH":/backup alpine sh -c "rm -rf /volume/* /volume/..?* /volume/.[!.]*; tar -C /volume/ -xf /backup/$BACKUP_NAME"
  if [ $? -eq 0 ]; then
    echo "success !"
  else
    echo "error :<"
  fi

}

function volume_exists() {

  if (( $# < 1 )); then
    echo "error : missing volume name argument"
    return 1
  fi
  VOLUME_NAME=$1
  docker volume inspect "$VOLUME_NAME" &>/dev/null || return 1
  return 0

}

function print_usage() {
  echo "Usage :"
  echo "    volume-backup backup <VOLUME_NAME> <DESTINATION_PATH>"
  echo "    volume-backup restore <VOLUME_NAME> <BACKUP_PATH>"
}

if (( $# < 1 )); then
  print_usage
  exit 1
fi

case "$1" in
  "backup")
    shift
    backup $@
    ;;
  "restore")
    shift
    restore $@
    ;;
  *)
    echo "unknown command"
    print_usage
    exit 1
    ;;
esac

exit 0
