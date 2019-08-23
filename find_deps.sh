#! /usr/bin/env bash

# This script looking for all shared libraries dependent from given. 


if [  -z $1 ]
then 
	echo "No libarary name specified"
	exit 1
fi

given_lib=$1

libs=$(find -name "*.so")

for l in $libs
do
	present=$(ldd $l | grep $given_lib | awk '{ print $1 }')

	if [ -z $present ]
	then 
		continue
	fi
	#basename $l
	echo $l
done



