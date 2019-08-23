#! /usr/bin/env bash
set -x
dirs=$(find -type d -name build)

for d in $dirs
do 
	rm -rf $d/*
done

