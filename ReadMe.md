# flowtmux

flowtmux is a tmux helper for the FlowTime (or Flowmodoro) method. It's a variant
of the pomodoro method designed to let the user reach a state of flow.

## Features (TODO)

- [x] Start a timer
- [x] Pause a timer
- [x] Show the timer in tmux
- [x] When the timer gets paused, we append the period (start and end timestamp,
      name of the session) to tmux
- [x] Tmux keybindings for toggle and stop
- [ ] Option for minimum session time to be added to the log file
- [ ] Automated pauses (session_time / 5)
- [ ] Option for the length of pauses compared to session time
- [ ] Option for minimum session time before automated pause
- [ ] Get the name of the current tmux session as the session name
- [ ] At the end of a session, show a menu to discard or log the session
- [ ] Use like a tpm plugin

## Implementation

- Store all state in files inside a temporary directory
- Store the beginning of the timer as timestamp

## States

- not started: there's no action to take yet -> check for status file, if not
  exist, we're in this state
- in_progress: the timer is running
- waiting for user action: if the
