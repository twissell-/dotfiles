#!/bin/bash -eu
set -o pipefail

password_store="${HOME}/.password-store/"

function _rofi() {
    # shellcheck disable=SC2068
    rofi -dmenu -theme-str '* {font: "Monospace Bold 14";} listview {columns: 1;}' $@ # -lines "$LINENUM" -a "$HIGHLINE" -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -font "$FONT" -width -"$RWIDTH"
}

function _notify() {
    local msg="${1}"

    notify-send --app-name="rofi-wifi-menu" "rofi-wifi-menu" "${msg}"
}

function _list_password() {
    cd "${password_store}" && find . -type f ! -name .gpg-id | sed -e "s/\.\///" -e 's/\.gpg//'
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

    # case "${entry}" in
    # "Search networks")
    #     _search_networks
    #     ;;
    # "Manual connection")
    #     _manual_connection
    #     ;;
    # "Turn Wi-Fi off")
    #     nmcli radio wifi off
    #     ;;
    # "Turn Wi-Fi on")
    #     nmcli radio wifi on
    #     ;;
    # *)
    #     :
    #     ;;
    # esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
