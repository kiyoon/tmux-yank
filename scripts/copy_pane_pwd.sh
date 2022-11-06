#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPERS_DIR="$CURRENT_DIR"

# shellcheck source=scripts/helpers.sh
source "${HELPERS_DIR}/helpers.sh"

pane_current_path() {
    tmux display -p -F "#{pane_current_path}"
}

display_notice() {
    display_message 'PWD copied to clipboard!'
}

main() {
    local copy_command
    local payload
    # shellcheck disable=SC2119
    copy_command="$(clipboard_copy_command)"
    payload="$(pane_current_path | tr -d '\n')"
    
    # WSL clipboard command `cat | clip.exe` doesn't work because it includes the pipe character.
    # Instead, use `clip.exe`.
    if type "clip.exe" >/dev/null 2>&1; then
        echo "$payload" | clip.exe
    else
        # $copy_command below should not be quoted
        echo "$payload" | $copy_command
    fi
    
    tmux set-buffer "$payload"
    display_notice
}
main
