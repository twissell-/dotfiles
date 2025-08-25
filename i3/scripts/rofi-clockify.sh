#!/bin/bash -eu
set -o pipefail

WORKSPACE_ID="$(pass dotfiles/clockify/workspace-id)"
USER_ID="$(pass dotfiles/clockify/user-id)"
API_TOKEN="$(pass dotfiles/clockify/api-token)"
ROFI_THEME_OVERRIDE='* {font: "Monospace Bold 14";} listview {columns: 1; lines: 15;} window { height: 720px; width: 480px;}'
PROJECTS=""
ENTRIES=""

function _rofi() {
    # shellcheck disable=SC2068
    rofi -dmenu -theme-str "${ROFI_THEME_OVERRIDE}" $@
}
function _start_entry() {
    local description="${1}"
    local project_id="${2}"
    local entry

    entry="$(curl -s \
        -H "Content-Type: application/json" \
        -H "X-Api-Key: ${API_TOKEN}" \
        -X POST "https://api.clockify.me/api/v1/workspaces/${WORKSPACE_ID}/time-entries" \
        -d "{\"description\": \"${description}\", \"projectId\": \"${project_id}\"}")"
}

function _list_projects() {
    PROJECTS="$(curl -s \
        -H "Content-Type: application/json" \
        -H "X-Api-Key: ${API_TOKEN}" \
        -X GET "https://api.clockify.me/api/v1/workspaces/${WORKSPACE_ID}/projects?hydrated=true" |
        jq -c '[.[] | {id, name: (.client.name + " | " + .name) | ascii_downcase}] | sort_by(.name) | .[]')"
}

function _list_last_entries() {
    local end_date
    local start_date

    start_date="$(date -d '14 days ago 00:00:00' +"%Y-%m-%dT00:00:00.000Z")"
    end_date="$(date -d 'today 00:00:00' +"%Y-%m-%dT00:00:00.000Z")"

    ENTRIES="$(curl -s \
        -H "Content-Type: application/json" \
        -H "X-Api-Key: ${API_TOKEN}" \
        -X GET "https://api.clockify.me/api/v1/workspaces/${WORKSPACE_ID}/user/${USER_ID}/time-entries?hydrated=true&start=${start_date}&end=${end_date}" |
        jq -c '[.[] | {description, project_id: .project.id}] | sort_by(.description) | .[]' | uniq | jq -c)"
}

function new_entry() {
    local description
    local project
    local project_id

    _list_projects

    description="$(_rofi -p "Description: ")"
    project="$(jq -r '.name' <<< "${PROJECTS}" | _rofi -p "Project: ")"
    project_id="$(grep "\"${project}\"" <<< "${PROJECTS}" | jq -r .id)"

    _start_entry "${description}" "${project_id}"
}

function continue_entry() {
    local description
    local project_id

    _list_last_entries

    description="$(jq -r '.description' <<< "${ENTRIES}" | _rofi -p "Description: ")"
    project_id="$(grep "\"${description}\"" <<< "${ENTRIES}" | jq -r .project_id)"

    _start_entry "${description}" "${project_id}"
}

function stop_entry() {
    local entry

    entry="$(curl -s \
        -H "Content-Type: application/json" \
        -H "X-Api-Key: ${API_TOKEN}" \
        -X PATCH "https://api.clockify.me/api/v1/workspaces/${WORKSPACE_ID}/user/${USER_ID}/time-entries" \
        -d "{\"end\": \"$(date -u +"%Y-%m-%dT%T.000Z")\"}")"
}

function main() {
    local options
    local entry

    options+="CONTINUE\n"
    options+="NEW\n"
    options+="STOP"

    entry="$(echo -e "${options}" | _rofi -p "Clockify: ")"

    case "${entry}" in
    "NEW")
        new_entry
        ;;
    "STOP")
        stop_entry
        ;;
    "CONTINUE")
        continue_entry
        ;;
    *)
        :
        ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
