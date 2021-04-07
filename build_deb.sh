#! /usr/bin/env bash
set +x

# Download and unpack
URL=https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/
FILENAME=imx-gpu-viv
FILEVER=$(cat binary.version)
CHKSUM=$(cat binary.md5sum)
FILEARCH=aarch64
FULLNAME=$FILENAME-$FILEVER-$FILEARCH

if [ ! -f $FULLNAME.bin ]
then
    wget $URL/$FULLNAME.bin && chmod +x $FULLNAME.bin
fi

md5sum -c - <<< "$CHKSUM  $FULLNAME.bin"
if [ "$?" != "0" ]; then
    echo "Error: Checksum verification failed. Aborting!"
    exit 1
fi

./$FULLNAME.bin --auto-accept

# Organize files for packaging
mkdir imx-gpu-viv-src
mv $FULLNAME/gpu-core/ imx-gpu-viv-src
mv $FULLNAME/gpu-demos/ imx-gpu-viv-src
mv $FULLNAME/gpu-tools/ imx-gpu-viv-src
cd imx-gpu-viv-src

# Special case for libVDK on Wayland backend, deliver fb library as well
cp gpu-core/usr/lib/fb/libVDK.so.1.2.0 gpu-core/usr/lib/wayland/libVDK-fb.so.1.2.0

# Remove files for backends other than wayland
rm -rf gpu-core/usr/lib/x11 gpu-core/usr/lib/fb

# Use vulkan header from vulkan-headers recipe to support vkmark benchmark
rm -rf gpu-core/usr/include/vulkan/

# Rename our libvulkan.so so it doesn't clash with vulkan-loader libvulkan.so
mv gpu-core/usr/lib/wayland/libvulkan.so.1.1.6 gpu-core/usr/lib/wayland/libvulkan_VSI.so.1.1.6
patchelf --set-soname libvulkan_VSI.so.1 gpu-core/usr/lib/wayland/libvulkan_VSI.so.1.1.6
ln -sf libvulkan_VSI.so.1.1.6 gpu-core/usr/lib/wayland/libvulkan_VSI.so.1
ln -sf libvulkan_VSI.so.1.1.6 gpu-core/usr/lib/wayland/libvulkan_VSI.so
rm gpu-core/usr/lib/wayland/libvulkan.so*

# Separate .so files for the development package
# Only copy the .so files that are symlinks, rest go inside the runtime package
mkdir sodev
find gpu-core -type l -name *.so -exec mv {} sodev \;

# Prepare .pc files for installation
cd gpu-core/usr/lib/pkgconfig
mv gl_x11.pc gl.pc
rm *linuxfb.pc *x11.pc egl.pc
mv egl_wayland.pc egl.pc
sed -i 's@^libdir.*@libdir=/usr/lib/aarch64-linux-gnu@' *.pc
cd -

cd ..

rm $FULLNAME.bin
rm -rf $FULLNAME

# Debianize the sources with debmake
TOPDIR=$(pwd)
SRCDIR=imx-gpu-viv-src
BUILDDIR=build
DEBDIR=debian

mkdir -p $BUILDDIR
tar --transform "s/^$SRCDIR/imx-gpu-viv-$FILEVER/" -czf $BUILDDIR/imx-gpu-viv-$FILEVER.tar.gz $SRCDIR
cd $BUILDDIR
tar xzf imx-gpu-viv-$FILEVER.tar.gz
cd imx-gpu-viv-$FILEVER
cp -rf $TOPDIR/$DEBDIR .
debmake

# Build the packages
debuild -us -uc

# Copy binaries
cd ..
mkdir debs
mv *.deb debs
rm debs/*dbgsym*

# Report conflicting files in all packages
echo "Searching for conflicting files in all packages"
echo "The following output can be used to update the package relationships in the control file"

rm -rf tmp && mkdir tmp
builddir=$(pwd)
for file in debs/*.deb
do
    pkgname=$(echo $file | grep -Eo "imx-gpu-viv.[a-z,-]*")
    echo "Searching for conflicting files in package \"$pkgname\"":
    dpkg -x $file tmp/$pkgname
    rm tmp/$pkgname/usr/share -rf
    cd tmp/$pkgname
    find . -type f,l | sed 's/^.//' | apt-file search -F -f "-"
    cd $builddir
done
