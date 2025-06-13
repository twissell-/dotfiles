#!/bin/bash
# Author: klaxalk (klaxalk@gmail.com, github.com/klaxalk)
#
# Dependencies:
# - vim/nvim  : scriptable file editing
# - jq        : json manipulation
# - rofi      : nice dmenu alternative
# - xdotool   : window manipulation
# - xrandr    : getting info of current monitor
# - i3-msg    : i3 tui
# - awk+sed+cat ...
#
# vim: set foldmarker=#\ #{,#\ #}

layout_dir=~/.screenlayout/

# if operating using dmenu
options="Open arandr
Load layout"
if [ -z $1 ]; then

    ACTION=$(echo "$options" | rofi -i -dmenu -no-custom -p "Select action")

    if [ -z "$ACTION" ]; then
        exit
    fi

fi

case "$ACTION" in
"Open arandr")
    arandr
    ;;
"Load layout")
    layout=$(ls -1 "${layout_dir}" | rofi -i -dmenu -no-custom -p "Select action")

    if [ -z "$layout" ]; then
        exit
    else
        "${layout_dir}/${layout}"
        notify-send -u low -t 2000 "Loaded ${layout%%.sh}" -h string:x-canonical-private-synchronous:anything

    fi

    ;;
*)
    command ...
    ;;
esac
