#! /usr/bin/env bash
set -x

DIR=../gpu-core/usr

mkdir -p src

files=$(cat src.list)

for f in $files
do
	cp -d $DIR/$f src 
done


