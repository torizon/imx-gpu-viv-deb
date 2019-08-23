#! /usr/bin/env bash

TARGET_NAME=binarylibs

base_repo="ssh://git@gitlab.int.toradex.com:8022/rd/torizon-core/debian/debian-package-devel.git"
is_base_exists=$(docker images | grep debian-package-devel-base | awk '{print $1}')

if [ -z $is_base_exists ]
then
	git clone $base_repo && cd debian-package-devel && time docker build -f Dockerfile -t debian-package-devel-libdrm . && cd -
fi

set -x
time docker build --no-cache -f Dockerfile.$TARGET_NAME -t debian-package-devel-$TARGET_NAME .
