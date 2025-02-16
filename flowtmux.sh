#!/bin/bash

TMP_DIR="/tmp/flowtmux/"
START_FILE="$TMP_DIR/start.txt"
STATUS_FILE="$TMP_DIR/status.txt"
SESSION_NAME_FILE="$TMP_DIR/session_name.txt"
FLOWTMUX_DIR="$HOME/.flowtmux/"
LOG_FILE="$FLOWTMUX_DIR/log.txt"

flow_read() {
  status=$(get_status)
  current_time=$(get_time)

  if [ "$status" = "in_progress" ]; then
    start_time=$(get_start_time)
    total_seconds=$(($current_time - $start_time))
    printf "%sm" $((total_seconds / 60))
  elif [ "$status" = "paused" ]; then
    printf "paused"
  fi
}

flow_toggle() {
  status=$(get_status)
  if [ "$status" = "in_progress" ]; then
    flow_pause
    return 0
  elif [ -z "$status" ] || [ "$status" = "paused" ]; then
    flow_start "new session"
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

  echo "$1" > $SESSION_NAME_FILE

  get_time > $START_FILE
  set_status "in_progress"
}

flow_pause() {
  pause_time=$(get_time)
  set_status "paused"

  printf "%s\t%s\t%s" $(get_start_time) $pause_time $(get_session_name) >> $LOG_FILE
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
  cat "$SESSION_NAME_FILE"
}

set_status() {
  echo "$1" > $STATUS_FILE
}

main() {
  cmd=$1
  shift 1

  if [ "$cmd" = "start" ]; then
    flow_start $@
  elif [ "$cmd" = "pause" ]; then
    flow_pause
  elif [ "$cmd" = "read" ]; then
    flow_read
  elif [ "$cmd" = "toggle" ]; then
    flow_toggle
  else
    echo "Unknown command $cmd"
  fi
}

main $@
