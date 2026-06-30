#!/usr/bin/env bash
# Pick a folder under ~/dev and open/attach a tmux session named after it.
# Bound to `prefix o` (see tmux.conf). Runs inside a display-popup.

selected=$(find ~/dev -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
    | sort \
    | fzf --reverse --prompt='dev> ')
[ -z "$selected" ] && exit 0

# tmux session names can't contain dots/colons — sanitize.
name=$(basename "$selected" | tr '.:' '__')

# Create the session detached if it doesn't exist yet, then switch to it.
tmux has-session -t "=$name" 2>/dev/null || tmux new-session -ds "$name" -c "$selected"
tmux switch-client -t "=$name"
