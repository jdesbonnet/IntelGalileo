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
