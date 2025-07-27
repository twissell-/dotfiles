#!/bin/bash


if command -v pactl &> /dev/null; then
    mic_properties=$(pacmd list-sources | sed -n '/* index: /,/current latency/p')
    mic_index=$(echo "${mic_properties}" | grep '* index' | awk '{print $3}')
    is_muted=$(echo "${mic_properties}" | grep 'muted:' | awk '{print $2}')

    pactl set-source-mute "${mic_index}" toggle

    if [[ "${is_muted}" = "yes" ]]; then
        icon="microphone-sensitivity-high"
        msg="Voiced"
    else
        icon="microphone-sensitivity-muted"
        msg="Muted"
    fi

    notify-send --hint=int:transient:1 -i "${icon}" --app-name="mic_control" "${msg}"

    exit 0
fi

if command -v alsamixer &> /dev/null; then
    amixer set Capture toggle

    if amixer get Capture | grep '\[off\]'; then
        icon="microphone-sensitivity-muted"
        msg="Muted"
    else
        icon="microphone-sensitivity-high"
        msg="Voiced"
    fi

    notify-send --hint=int:transient:1 -i "${icon}" --app-name="mic_control" "${msg}"

    exit 0
fi

exit 1

