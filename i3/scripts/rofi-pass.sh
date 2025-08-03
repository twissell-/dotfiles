#!/bin/bash -eu
set -o pipefail

PASSWORD_STORE="${HOME}/.password-store/"
ROFI_THEME_OVERRIDE='* {font: "Monospace Bold 14";} listview {columns: 1; lines: 15;} window { height: 720px; width: 480px;}'

function _rofi() {
    # shellcheck disable=SC2068
    rofi -dmenu -theme-str "${ROFI_THEME_OVERRIDE}" $@ # -lines "$LINENUM" -a "$HIGHLINE" -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -font "$FONT" -width -"$RWIDTH"
}

function _notify() {
    local msg="${1}"

    notify-send --app-name="rofi-wifi-menu" "rofi-wifi-menu" "${msg}"
}

function _list_password() {
    (cd "${PASSWORD_STORE}"; find . -type f -name '*.gpg') | sort -f | sed -e "s/\.\///" -e 's/\.gpg//'
}

function main() {
    local options
    local entry

    options="Search networks\n"
    options+="Manual connection\n"

    if nmcli -fields WIFI g | grep -q "enabled"; then
        options+="Turn Wi-Fi off"
    else
        options+="Turn Wi-Fi on"
    fi

    entry="$(_list_password | _rofi -p "pass: ")"

    pass -c "${entry}" 2> /dev/null
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
