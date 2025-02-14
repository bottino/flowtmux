# flowtmux

flotmux is a tmux helper for the FlowTime (or Flowmodoro) method. It's a variant
of the pomodoro method designed to let the user reach a state of flow.

## Features (TODO)

- Start a timer
- Pause a timer
- Show the timer in tmux
- When the timer gets paused, we append the period (start and end timestamp,
  name of the session) to tmux

## Implementation

- Store all state in files inside a temporary directory
- Store the beginning of the timer as timestamp
