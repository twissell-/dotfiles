#!/bin/bash

scrot /tmp/screen.png
#/home/damian/bin/xwobf/xwobf -s 4 /tmp/screen.png

# font=$(convert -list font | awk "{ a[NR] = \$2 } /family: $(fc-match sans -f "%{family}\n")/ { print a[NR-1]; exit }")
# font="Victor"
# bw="white"
# convert \
#     -scale 10% \
#     -scale 1000% \
#     -font "$font" -pointsize 26 -fill "$bw" -gravity center \
#     -annotate +0+160 "sarasa" \
#     /tmp/screen.png /tmp/screen.png

mogrify -scale 10% -scale 1000% /tmp/screen.png
i3lock -i /tmp/screen.png
rm /tmp/screen.png
