#!/bin/bash

if [ ! -d ~/.i3 ]; then
	mkdir ~/.i3
fi

if [ ! -d ~/.config/rofi ]; then
	mkdir -p ~/.config/rofi
fi

cp ./config ~/.i3/
cp ./i3status.conf ~/.i3status.conf
cp ./.i3blocks.conf ~/.i3blocks.conf
cp -r ./scripts ~/.i3/
cp ./rofi/* ~/.config/rofi/
