#! /usr/bin/env bash

set +x

dirs=$(find -type d -name build -o -name src)  

for d in $dirs
do 
	rm -rf $d
done

rm -rf gpu-core

