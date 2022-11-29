#!/bin/bash

cd /tmp
apt install build-essential checkinstall && apt-get build-dep imagemagick -y
wget http://www.imagemagick.org/download/ImageMagick.tar.gz
tar xzvf ImageMagick.tar.gz
cd ImageMagick-*
./configure --prefix=/opt/imagemagick && make
checkinstall

