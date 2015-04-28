#!/bin/bash
#
# Install dependencies needed to build Galileo board software. 
# Assuming the starting point is a  a fresh Ubuntu Server 12.04 i32 dist. 
#
# Joe Desbonnet, jdesbonnet@gmail.com, 27 April 2015.
# Public domain.
#

# A problem with liberror-perl while installing git: 
# http://askubuntu.com/questions/41605/trouble-downloading-packages-list-due-to-a-hash-sum-mismatch-error
rm /var/lib/apt/lists/*

apt-get update
apt-get upgrade
apt-get install git gcc g++ make texinfo gawk diffstat chrpath \

# Required to build ACPICA tools supporting ACPI 5.0
# This replaces the obsolute version in the ubuntu iasl package.
apt-get install m4 bison flex

# Required to build EDKII firmware
apt-get install subversion libcurl4-openssl-dev
