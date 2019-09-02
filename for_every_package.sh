#! /usr/bin/env bash

# This script traverse over directories and executes script passed as argument 

set +x

if [ -z $1 ]
then 
	echo "Require name of other script as argument"
	exit 1
fi

# src.list considered as a marker of directory for packaging
dirs=$(dirname $(find -name src.list))

echo $dirs

for d in $dirs
do
	cd $d; ../$1; cd -
done

