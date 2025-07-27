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
    test -r "${config_file}" && ! test -L "${config_file}" && create_backup "${config_file}"

    ln -sf "${src}/i3/config" "${config_file}" && echo "✔ Done" || echo "✖ Failed"
}

_install_rofi() {
    local config_file="${HOME}/.config/rofi/config.rasi"

    mkdir -p "$(dirname "${config_file}")"
    test -r "${config_file}" && ! test -L "${config_file}" && create_backup "${config_file}"

    ln -sf "${src}/rofi/config.rasi" "${config_file}" && echo "✔ Done" || echo "✖ Failed"
}

_install_starship() {
    local config_file="${HOME}/.config/starship.toml"

    mkdir -p "$(dirname "${config_file}")"
    test -r "${config_file}" && ! test -L "${config_file}" && create_backup "${config_file}"

    ln -sf "${src}/starship/starship.toml" "${config_file}" && echo "✔ Done" || echo "✖ Failed"
}

_install_dunst() {
    local config_file="${HOME}/.config/dunst/dunstrc"

    mkdir -p "$(dirname "${config_file}")"
    test -r "${config_file}" && ! test -L "${config_file}" && create_backup "${config_file}"

    ln -sf "${src}/dunst/dunstrc" "${config_file}" && echo "✔ Done" || echo "✖ Failed"
}

main() {
    declare -f | sed -nr 's#^(_install_.*)\(\)#\1#p' |
        sort |
        while read f; do
            printf "⤷ %s\\n" "${f//_install_/}"
            $f
        done
}

main "$@"
