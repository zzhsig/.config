#!/usr/bin/env bash
# Kill a session and switch the client to the 1st session (first by name).
# Bound to `prefix X` (see tmux.conf). Current session name is passed as $1.

cur="$1"
[ -z "$cur" ] && cur=$(tmux display-message -p '#S')

# First session by name, excluding the one we're about to kill.
target=$(tmux list-sessions -F '#{session_name}' | grep -vxF "$cur" | sort | head -1)

# Switch away first (avoids a flash through tmux's auto-pick), then kill.
[ -n "$target" ] && tmux switch-client -t "=$target"
tmux kill-session -t "=$cur"
