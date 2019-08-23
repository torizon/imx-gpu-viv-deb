#! /usr/bin/env bash

 set -x

TOPDIR=$(pwd)
# package name should be in lowercase.
# libraries inside save their names
LIBNAME=$(basename $TOPDIR | awk '{print tolower($0)}')
LIBVERSION="6.2.4.p2.3"
FULLNAME=$LIBNAME-$LIBVERSION
SRCDIR=src
BUILDDIR=build
DEBDIR=debian

rm -rf $BUILDDIR/*
tar --transform "s/^$SRCDIR/$FULLNAME/" -czvf $BUILDDIR/$FULLNAME.tar.gz $SRCDIR
cd $BUILDDIR
tar xzvf $FULLNAME.tar.gz
cd $FULLNAME
debmake 
cd debian

if [ -d $TOPDIR/$DEBDIR ] 
then
	cp -rf $TOPDIR/$DEBDIR/* .
fi

debuild -uc -us
cd ..

