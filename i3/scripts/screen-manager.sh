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

layout_dir="${HOME}/bin/dotfiles/screenlayout"

# if operating using dmenu
options="Load layout
Open arandr"
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
        ln -s "${layout_dir}/${layout}" "${layout_dir}/.latest"

        sleep 0.5
        feh --bg-scale "$(find "${HOME}/bin/dotfiles/wallpaper/active" -type f ! -name .gitkeep | sort -R | tail -1)"
        "${HOME}/bin/dotfiles/polybar/launch.sh"
        notify-send -u low -t 5000 "Loaded ${layout%%.sh}" -h string:x-canonical-private-synchronous:anything

    fi

    ;;
*)
    command ...
    ;;
esac
