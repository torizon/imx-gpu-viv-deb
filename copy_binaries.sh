#! /usr/bin/env bash

set +x

files=$(cat src.list)
mkdir -p src
for f in $files
do
	find ../gpu-core -name "$f" -exec cp -d {} src ';'
done

