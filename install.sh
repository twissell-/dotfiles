#!/bin/bash

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function create_backup() {
    local file_or_dir="$1"
    local backup_file

    backup_file="${file_or_dir}.$(date +%s).bk"

    if [[ -f "$file_or_dir" ]]; then
        cp "$file_or_dir" "$backup_file"
        echo "Backup created: $backup_file"
    elif [[ -d "$file_or_dir" ]]; then
        cp -r "$file_or_dir" "$backup_file"
        echo "Backup created: $backup_file"
    else
        echo "Not found: $file_or_dir"
    fi
}

# ln -s /home/damian/bin/dotfiles/i3 ~/.config/
# ln -s /home/damian/bin/dotfiles/polybar ~/.config/
# ln -s /home/damian/bin/dotfiles/polybar ~/.config/
# ln -s /home/damian/bin/dotfiles/i3blocks/ ~/.config/
# ln -s /home/damian/bin/dotfiles/rofi ~/.config/
# ln -s /home/damian/bin/dotfiles/redshift/ ~/.config/
# ln -s /home/damian/bin/dotfiles/dunst/ ~/.config/
# ln -s /home/damian/bin/dotfiles/starship/starship.toml ~/.config/
# ln -s /home/damian/bin/dotfiles/i3status-rust/ ~/.config/

_install_i3() {
    local config_file="${HOME}/.config/i3/config"

    mkdir -p "$(dirname "${config_file}")"
    # test -r "${config_file}" && ! test -L "${config_file}" && create_backup "${config_file}"

    if [[ -L "${config_file}" ]]; then
        echo " Skipped"
        return 0
    fi

    create_backup "${config_file}"
    ln -sf "${src}/i3/config" "${config_file}" && echo "✔ Done" || echo "✖ Failed"
}

_install_rofi() {
    local config_dir="${HOME}/.config/rofi"

    mkdir -p "${config_dir}"
    # test -r "${config_file}" && ! test -L "${config_file}" && create_backup "${config_file}"

    if [[ -L "${config_dir}" ]]; then
        echo " Skipped"
        return 0
    fi

    create_backup "${config_dir}"
    ln -sf "${src}/rofi" "${config_dir}" && echo "✔ Done" || echo "✖ Failed"
}

_install_starship() {
    local config_file="${HOME}/.config/starship.toml"

    mkdir -p "$(dirname "${config_file}")"
    # test -r "${config_file}" && ! test -L "${config_file}" && create_backup "${config_file}"

    if [[ -L "${config_file}" ]]; then
        echo " Skipped"
        return 0
    fi

    create_backup "${config_file}"
    ln -sf "${src}/starship/starship.toml" "${config_file}" && echo "✔ Done" || echo "✖ Failed"
}

_install_dunst() {
    local config_file="${HOME}/.config/dunst/dunstrc"

    mkdir -p "$(dirname "${config_file}")"
    # test -r "${config_file}" && ! test -L "${config_file}" && create_backup "${config_file}"

    if [[ -L "${config_file}" ]]; then
        echo " Skipped"
        return 0
    fi

    create_backup "${config_file}"
    ln -sf "${src}/dunst/dunstrc" "${config_file}" && echo "✔ Done" || echo "✖ Failed"
}

_install_gnome_terminal() {
    # shellcheck disable=SC2155
    local backup_file="${HOME}/.config/gnome-terminal/profile.dconf.$(date +%s).bk"
    local profile_file="${src}/gnome-terminal/profiles.dconf"

    if ! diff "${profile_file}" <(dconf dump /org/gnome/terminal/legacy/profiles:/) &> /dev/null; then
        mkdir -p "$(dirname "${backup_file}")"
        dconf dump /org/gnome/terminal/legacy/profiles:/ > "${backup_file}"

        # if this doesn't work, try:
        # dconf reset -f /org/gnome/terminal/legacy/profiles:/
        dconf load -f /org/gnome/terminal/legacy/profiles:/ < "${src}/gnome-terminal/profiles.dconf" && echo "✔ Done" || echo "✖ Failed"
    else
        echo " Skipped"
    fi
}

_install_autorandr() {
    local config_dir="${HOME}/.config/autorandr"

    mkdir -p "${config_dir}"
    # test -r "${config_dir}" && ! test -L "${config_dir}" && create_backup "${config_dir}"

    if [[ -L "${config_dir}" ]]; then
        echo " Skipped"
        return 0
    fi

    create_backup "${config_dir}" && rm -rf "${config_dir}"
    ln -sf "${src}/autorandr" "${config_dir}" && echo "✔ Done" || echo "✖ Failed"
}


main() {
    declare -f | sed -nr 's#^(_install_.*)\(\)#\1#p' |
        sort |
        while read f; do
            printf "⤷ %s\\t" "${f//_install_/}"
            $f
        done | column -t
}

main "$@"
