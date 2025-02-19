#!/bin/bash

TMP_DIR="/tmp/flowtmux/"
START_FILE="$TMP_DIR/start.txt"
STATUS_FILE="$TMP_DIR/status.txt"
FLOWTMUX_DIR="$HOME/.flowtmux/"
LOG_FILE="$FLOWTMUX_DIR/log.txt"

flowtmux_toggle

flow_read() {
  status=$(get_status)
  current_time=$(get_time)

  # If we didn't start yet don't show anything
  if [ -z "$status"]; then
    return 0

  elif [ "$status" = "in_progress" ]; then
    start_time=$(get_start_time)
    total_seconds=$(($current_time - $start_time))
    printf "⏱︎%sm" $((total_seconds / 60))

  elif [ "$status" = "paused" ]; then
    printf "paused"

  fi
}

flow_toggle() {
  status=$(get_status)
  # Don't return anything is we didn't start
  if [ "$status" = "no_status" ]; then
    return 0
  elif [ "$status" = "in_progress" ]; then
    flow_pause
    return 0
  elif [ -z "$status" ] || [ "$status" = "paused" ]; then
    flow_start "unknown"
    return 0
  else
    printf "Unknown status $status"
    exit 1
  fi
}

flow_start() {
  rm -rf "$TMP_DIR"
  mkdir "$TMP_DIR"
  mkdir -p $FLOWTMUX_DIR

  get_time > $START_FILE
  set_status "in_progress"
  refresh_statusline
}

flow_pause() {
  pause_time=$(get_time)
  set_status "paused"

  printf "%s\t%s\t%s\n" $(get_start_time) $pause_time $(get_session_name) >> $LOG_FILE
  refresh_statusline
}

flow_stop() {
  rm -rf "$TMP_DIR"
  refresh_statusline
}

get_time() {
  echo "$(date +%s)"
}

get_start_time() {
  cat $START_FILE
}

get_status() {
  cat $STATUS_FILE
}

get_session_name() {
  if [ if_inside_tmux ]; then
    # get the tmux session name
    tmux display-message -p '#S'
  else
    cat "unknown"
  fi
}

set_status() {
  echo "$1" > $STATUS_FILE
}

if_inside_tmux() {
	test -n "${TMUX}"
}

refresh_statusline() {
	if_inside_tmux && tmux refresh-client -S
}

main() {
  cmd=$1

  if [ "$cmd" = "start" ]; then
    flow_start
  elif [ "$cmd" = "pause" ]; then
    flow_pause
  elif [ "$cmd" = "toggle" ]; then
    flow_toggle
  elif [ "$cmd" = "stop" ]; then
    flow_stop
  else
    flow_read
  fi
}

main $@
