#!/bin/bash -eu
set -o pipefail

# based on https://github.com/zbaylin/rofi-wifi-menu/blob/master/rofi-wifi-menu.sh

function _notify() {
    local msg="${1}"

    notify-send --app-name="rofi-wifi-menu" "rofi-wifi-menu" "${msg}"
}

function _connect() {
    local ssid="${1}"
    local pass="${2}"
    local known_nets
    local current_net

    current_net=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')
    if [[ "${current_net}" = "${ssid}" ]]; then
        return 0
    fi

    known_nets=$(nmcli --fields name connection show | tail -n +2)
    if grep -q "${ssid}" <<< "${known_nets}"; then
        msg="$(nmcli con up "${ssid}" 2>&1)"
    elif [[ -n "${pass}" ]]; then
        msg="$(nmcli dev wifi con "${ssid}" password "${pass}" 2>&1)"
    else
        msg="$(nmcli dev wifi con "${ssid}" 2>&1)"
    fi

    _notify "${msg}"
}

function _manual_connection() {
    local input
    local ssid
    local pass
    local msg

    # Manual entry of the SSID and password (if appplicable)
    input=$(echo "enter the SSID of the network (SSID[,password])" | rofi -dmenu -p "SSID: " -lines 1)
    # Separating the password from the entered string
    ssid=$(echo "$input" | awk -F "," '{print $1}')
    pass=$(echo "$input" | awk -F "," '{print $2}')

    _connect "${ssid}" "${pass}"
}

function _search_networks() {
    local net_list
    local entry
    local ssid

    # TODO: see how to remove duplicates
    net_list=$(nmcli --fields "bars,ssid,security" device wifi list | sed '/\ --\ /d' | uniq | tail -n +2)
    entry=$(echo -e "$net_list" | rofi -dmenu -p "SSID: ") # -lines "$LINENUM" -a "$HIGHLINE" -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -font "$FONT" -width -"$RWIDTH"

    ssid=$(echo "$entry" | awk -F " " '{print $2}')

    _connect "${ssid}"
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

    entry="$(echo -e "${options}" | rofi -dmenu -p "Wi-Fi menu: ")"

    case "${entry}" in
    "Search networks")
        _search_networks
        ;;
    "Manual connection")
        _manual_connection
        ;;
    "Turn Wi-Fi off")
        nmcli radio wifi off
        ;;
    "Turn Wi-Fi on")
        nmcli radio wifi on
        ;;
    *)
        :
        ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
