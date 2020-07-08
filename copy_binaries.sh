#! /usr/bin/env bash
set -x

DIR=../gpu-core

mkdir -p src

files=$(cat src.list)

for f in $files
do
	cp -rd $DIR/$f src 
done

