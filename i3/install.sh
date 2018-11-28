#!/bin/bash

if [ ! -d ~/.i3 ]; then
	mkdir ~/.i3
fi

cp ./config ~/.i3/
cp ./i3status.conf ~/i3status.conf
cp -r ./scripts ~/.i3/
