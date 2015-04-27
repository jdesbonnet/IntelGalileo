#!/bin/bash
#
# Install dependencies needed to build Galileo board software. 
# Assuming the starting point is a  a fresh Ubuntu Server 12.04 i32 dist. 
#
# Joe Desbonnet, jdesbonnet@gmail.com, 27 April 2015.
# Public domain.
#
rm /var/lib/apt/lists/*
apt-get update
apt-get upgrade
apt-get install git
