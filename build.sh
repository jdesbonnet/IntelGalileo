if [ ! -e 1.0.4.tar.gz ]; then
wget https://github.com/01org/Galileo-Runtime/archive/1.0.4.tar.gz
fi

tar -xf 1.0.4.tar.gz
cd Galileo-Runtime-1.0.4

tar -xf patches_v1.0.5.tar.gz

tar -xf meta-clanton_v1.0.5.tar.gz

./patches_v1.0.5/patch.meta-clanton.sh

cd meta-clanton_v1.0.5
source poky/oe-init-build-env yocto_build
bitbake image-spi-galileo

tar -xf Quark_EDKII_v1.0.2.tar.gz
./patches_v1.0.5/patch.Quark_EDKII.sh 
./svn_setup.py
svn update

export GCCVERSION=$(gcc -dumpversion | cut -c 3)

# This is currently failing due to the following:
# GenFvInternalLib.c:26:23: fatal error: uuid/uuid.h: No such file or directory
./quarkbuild.sh -r32 GCC4${GCCVERSION} QuarkPlatform

