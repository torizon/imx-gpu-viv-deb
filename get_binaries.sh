#! /usr/bin/env bash
set -x
URL=https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/
FILENAME=imx-gpu-viv
FILEVER=6.2.4.p4.0
FILEARCH=aarch64
FULLNAME=$FILENAME-$FILEVER-$FILEARCH
ARCHNAME=$FULLNAME.bin

if [ ! -f $ARCHNAME ]
then
	wget $URL/$ARCHNAME && chmod +x $ARCHNAME
fi

./$ARCHNAME

rm -rf gpu-core
mv $FULLNAME/gpu-core/ .

rm $ARCHNAME
rm -rf $FULLNAME



