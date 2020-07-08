#! /usr/bin/env bash
set +x
URL=https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/
FILENAME=imx-gpu-viv
FILEVER=$(cat binary.version)
FILEARCH=aarch64
FULLNAME=$FILENAME-$FILEVER-$FILEARCH
ARCHNAME=$FULLNAME.bin

if [ ! -f $ARCHNAME ]
then
	wget $URL/$ARCHNAME && chmod +x $ARCHNAME
fi

./$ARCHNAME --auto-accept

rm -rf gpu-core
mv $FULLNAME/gpu-core/ .

rm -rf gpu-demos
mv $FULLNAME/gpu-demos/ .

rm $ARCHNAME
rm -rf $FULLNAME

