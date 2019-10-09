#! /usr/bin/env bash

if [ -z $1 ]
then
	echo Container image name not specified.
	exit 1
fi

IMAGE_NAME=$1

#VOL_GITCONFIG="--volume ~/.gitconfig:/home/debian/.gitconfig"
#VOL_GPG="--volume /home/../../gnupg/:/home/debian/.gnupg"
#VOL_DEBPKG="--volume /home/../../debian-pkg/:/home/debian/debian-pkg"

VOL_DEB="--volume $(pwd)/.ssh:/home/debian/.ssh"
VOL_DEB="--volume $(pwd):/home/debian/DEB"

VOLUMES="$VOL_DEB"

ENV="--env-file env.list"
USER="--user debian"

set -x
docker run -it --rm $USER $ENV $VOLUMES --workdir /home/debian $IMAGE_NAME /bin/bash
