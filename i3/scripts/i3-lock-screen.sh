#!/bin/bash

scrot /tmp/screen.png  
#/home/damian/bin/xwobf/xwobf -s 4 /tmp/screen.png  
#convert -scale 10% -scale 1000% /tmp/screen.png /tmp/screen.png
mogrify -scale 10% -scale 1000% /tmp/screen.png
i3lock -i /tmp/screen.png  
rm /tmp/screen.png  
