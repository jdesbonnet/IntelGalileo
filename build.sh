#!/bin/bash
#
# Script to build Intel Galileo software distribution on 
# Ubuntu 12.04 32 bit server edition. There are some 
# dependencies that must be installed first. See file
# install-missing-packages.sh.
#
# Status: this script is almost working but failing at the last step (building
# firmware upload file). Date: 27 April 2015. 
#
# Build instructions seem to be very epheremal and likely not to fully work
# any significat time after the above date.
# 
# Adapted from instructions in file:
# BSP-Patches-and-Build_Instructions.1.0.4.txt at 
# http://downloadmirror.intel.com/24355/eng/BSP-Patches-and-Build_Instructions.1.0.4.txt
# Also see: 
# http://downloadmirror.intel.com/23962/eng/Quark_BSP_BuildandSWUserGuide_329687_007.pdf



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

# Check this
cd ..
# TODO: not sure what dir I'm in here.
pwd

#
#  Build EDKII (Part 4 of the User Guide)
#

# First build ACPICA tools (normally in iasl package, but ubuntu 12.04 version
# does not support ACPI5.0 which is required here. So build from source.

# There seems to be a problem with the certificate
wget --no-check-certificate https://acpica.org/sites/acpica/files/acpica-unix-20150410.tar.gz
cd  acpica-unix-20150410
make
sudo make install

cd ..

tar -xf Quark_EDKII_v1.0.2.tar.gz
cd Quark_EDKII_v1.0.2
# 5.3. Prepare the build environment (Part 4.2.1 of the User Guide)
./patches_v1.0.5/patch.Quark_EDKII.sh 
./svn_setup.py
svn update

export GCCVERSION=$(gcc -dumpversion | cut -c 3)

# 5.4. Build EDKII (Part 4.4 of the User Guide)
#
# This is currently failing due to the following:
# GenFvInternalLib.c:26:23: fatal error: uuid/uuid.h: No such file or directory
# Solution: install missing package uuid-dev
#
# Next failing due to the following:
# /bin/sh: 1: /usr/bin/iasl: not found
# Solution: install issing package iasl. Update: wrong solution. Need to build
# version that supports ACPI 5.0 from source.
#
# Next failing due to the following:
#  Object does not exist ^  (\_SB.PCI0.SDIO)
# Discussed here: http://stackoverflow.com/questions/28837504/intel-galileo-bsp-quark-edkii-error-4063
# Solution: Turns out the iasl package in ubuntu archive supports ACPI 4.0.
# Need ACPI 5.0. So need to build this from sources.
./quarkbuild.sh -r32 GCC4${GCCVERSION} QuarkPlatform

# 5.5. Create a symlink for SPI Flash Tools
export GCCVERSION=$(gcc -dumpversion | cut -c 3)
ln -s RELEASE_GCC4${GCCVERSION} Build/QuarkPlatform/RELEASE_GCC


cd ..

#6. Create a flash Image (SPI) (Part 8 of the User Guide)

#6.1. Unarchive sysimage package
tar -xf sysimage_v1.0.1.tar.gz

#6.2. Patch the sysimage package
./patches_v1.0.5/patch.sysimage.sh 


#6.3. Build SPI
tar -xf spi-flash-tools_v1.0.1.tar.gz
./sysimage_v1.0.1/create_symlinks.sh
cd sysimage/sysimage.CP-8M-release



# Failing due to:
# ../../spi-flash-tools/asset-signing-tool/sign.c:48:24: fatal error: openssl/bn.h: No such file or directory
# Solution: install package libcurl4-openssl-dev (it's possible only a subset of what's install is needed tho')
#
# Failing due to: 
#  ../../spi-flash-tools/BaseTools/x86_64/C/bin/GenFw: Syntax error: "(" unexpected
# Discussed here: https://communities.intel.com/thread/48689
../../spi-flash-tools/Makefile


