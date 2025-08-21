#!/bin/bash
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

default_toggle_key="t"
toggle_key_option="@flowtmux_toggle"
default_stop_key="T"
stop_key_option="@flowtmux_stop"
# Add a suffix to the statusbar pattern. Useful for separators
default_suffix=""
suffix_option="@flowtmux_suffix"

get_tmux_option() {
	local option="$1"
	local default_value="$2"

	option_value=$(tmux show-option -gqv "$option")

	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_option() {
	local option="$1"
	local value="$2"
	tmux set-option -gq "$option" "$value"
}

set_keybindings() {
  toggle_key=$(get_tmux_option $toggle_key_option $default_toggle_key)
  stop_key=$(get_tmux_option $stop_key_option $default_stop_key)
	tmux bind-key "$toggle_key" run-shell "$CURRENT_DIR/scripts/flowtmux.sh toggle"
	tmux bind-key "$stop_key" run-shell "$CURRENT_DIR/scripts/flowtmux.sh stop"
}

update_tmux_option() {
  # Set the status-right and status-left option
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
  local suffix=$(get_tmux_option $suffix_option $default_suffix)
  local pattern="\#{flowtmux}"
  local flowtmux_read="#($CURRENT_DIR/scripts/flowtmux.sh -s '$suffix')"
	local interpolated="${option_value//$pattern/$flowtmux_read}"
	set_tmux_option "$option" "$interpolated"
}

main() {
  set_keybindings
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}

main
