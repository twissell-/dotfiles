#!/bin/bash -eu
set -o pipefail

direction="${1:-}"
magnitude="${2:-5}"

if ! grep -qE "up|down" <<< "${direction}"; then
    echo "Usage: $0 [up|down]"
    exit 1
fi

if [[ "${direction}" == "up" ]]; then
    direction="+"
else
    direction="-"
fi

# check if pactl is insalled
if command -v pactl &> /dev/null; then
    device="$(pactl list | grep RUNNING -B1 | head -n1 | cut -d'#' -f2)"
    pactl set-sink-volume "${device}" "${direction}${magnitude}%"
    exit 0
fi

# if alsamix is installed
if command -v alsamixer &> /dev/null; then
    amixer -q set Master "${magnitude}%${direction}"
    exit 0
fi

exit 1
