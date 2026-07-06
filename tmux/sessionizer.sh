#!/usr/bin/env bash
# Pick a git project anywhere under ~/dev and open/attach a tmux session for it.
# A project is any directory containing a .git entry (dir or file). Bound to
# `prefix o` (see tmux.conf). Runs inside a display-popup.

dev=~/dev

# Find every .git entry at any depth, take its parent (the repo root), and stop
# descending into a repo once found so nested .git don't clutter the list.
# node_modules and .claude (worktree internals) are pruned for speed and noise.
# Paths are shown relative to ~/dev for a compact picker.
selected=$(find "$dev" \( -name node_modules -o -name .claude \) -prune -o \
    -name .git -prune -exec dirname {} \; 2>/dev/null \
    | sort -u \
    | sed "s|^$dev/||" \
    | fzf --reverse --prompt='dev> ')
[ -z "$selected" ] && exit 0

selected="$dev/$selected"

# tmux session names can't contain dots/colons — sanitize the relative path so
# projects with the same basename in different folders don't collide.
name=$(echo "$selected" | sed "s|^$dev/||" | tr './:' '___')

# Create the session detached if it doesn't exist yet, then switch to it.
tmux has-session -t "=$name" 2>/dev/null || tmux new-session -ds "$name" -c "$selected"
tmux switch-client -t "=$name"
