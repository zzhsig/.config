#!/bin/sh
prev=$(tmux show -gv @_prev_session 2>/dev/null)
[ -n "$prev" ] && tmux set -g @last-session "$prev"
tmux set -g @_prev_session "$(tmux display-message -p '#S')"
