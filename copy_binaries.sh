#! /usr/bin/env bash

#set -x

files=$(cat src.list)
mkdir -p src
for f in $files
do
	cp -d ../gpu-core/usr/lib/$f src
done

