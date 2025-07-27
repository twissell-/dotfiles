#!/usr/bin/env bash

workdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

echo "---" | tee -a /tmp/polybar.log
if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload main -c "${workdir}/config.ini" 2>&1 | tee -a /tmp/polybar.log &
        disown
    done
else
    polybar --reload main -c "${workdir}/config.ini" 2>&1 | tee -a /tmp/polybar.log &
    disown
fi

# echo "---" | tee -a /tmp/polybar.log
# polybar main -c "${workdir}/config.ini" 2>&1 | tee -a /tmp/polybar.log &
# disown

echo "main bar launched..."
