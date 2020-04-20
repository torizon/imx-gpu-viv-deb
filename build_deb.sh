#! /usr/bin/env bash

set +x

TOPDIR=$(pwd)
# package name should be in lowercase.
# libraries inside save their names
LIBNAME=$(basename $TOPDIR | awk '{print tolower($0)}')
LIBVERSION=$(cat ../binary.version)
FULLNAME=$LIBNAME-$LIBVERSION
SRCDIR=src
BUILDDIR=build
DEBDIR=debian

echo -e "\e[92m $FULLNAME \e[0m"

mkdir -p $BUILDDIR 
tar --transform "s/^$SRCDIR/$FULLNAME/" -czvf $BUILDDIR/$FULLNAME.tar.gz $SRCDIR
cd $BUILDDIR
tar xzvf $FULLNAME.tar.gz
cd $FULLNAME
debmake 
status=$?

if [ $status -ne 0 ]
then
	exit $status
fi

cd debian

if [ -d $TOPDIR/$DEBDIR ] 
then
	cp -rf $TOPDIR/$DEBDIR/* .
fi

debuild -uc -us
status=$?

if [ $status -ne 0 ]
then
	exit $status 
fi

cd ..

