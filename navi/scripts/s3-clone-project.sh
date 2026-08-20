#!/usr/bin/env bash
# Clone one or more TapVid project folders from an S3 bucket to the local mount.
#
# Usage: s3-clone-project.sh <bucket> <spec>
#
# <spec> accepts three forms (and any mix, comma-separated):
#   1. a single id            eval-run-e174214c-abcd
#   2. a comma-separated list id1,id2,id3
#   3. a wildcard pattern     'eval-run-e174214c-*'  (syncs every matching project)
#
# On success cd's into the last synced folder (only meaningful when the caller
# `source`s this script or evaluates its final `cd` line; see the cheat).
set -euo pipefail

bucket="${1:?usage: s3-clone-project.sh <bucket> <spec>}"
spec="${2:?usage: s3-clone-project.sh <bucket> <spec>}"

src_prefix="s3://${bucket}/workspace"
dst_root="${HOME}/mnt/bucket/${bucket}"

# Resolve a single spec entry into a list of concrete project ids.
resolve_ids() {
  local entry="$1"
  if [[ "$entry" == *"*"* || "$entry" == *"?"* || "$entry" == *"["* ]]; then
    # Wildcard: list the workspace prefix and glob-match folder names.
    aws s3 ls "${src_prefix}/" \
      | awk '/PRE /{print $2}' \
      | sed 's:/$::' \
      | while IFS= read -r name; do
          # shellcheck disable=SC2053
          [[ "$name" == $entry ]] && printf '%s\n' "$name"
        done
  else
    printf '%s\n' "$entry"
  fi
}

# Build the full id list from the comma-separated spec.
ids=()
IFS=',' read -ra entries <<<"$spec"
for entry in "${entries[@]}"; do
  entry="$(printf '%s' "$entry" | xargs)" # trim whitespace
  [[ -z "$entry" ]] && continue
  while IFS= read -r id; do
    [[ -n "$id" ]] && ids+=("$id")
  done < <(resolve_ids "$entry")
done

if [[ ${#ids[@]} -eq 0 ]]; then
  echo "No matching projects found for spec: $spec" >&2
  exit 1
fi

total=${#ids[@]}
echo "Cloning ${total} project(s) from ${bucket}:" >&2
printf '  - %s\n' "${ids[@]}" >&2

last_dst=""
succeeded=()
failed=0
i=0
for id in "${ids[@]}"; do
  i=$((i + 1))
  dst="${dst_root}/${id}/"
  echo "==> [${i}/${total}] aws s3 sync ${src_prefix}/${id}/ ${dst}" >&2
  # Route sync output to the terminal (fd 2, still a TTY) so aws renders its
  # live progress; stdout is reserved for the final cd target. Don't let a
  # single failed project abort the whole batch.
  if aws s3 sync "${src_prefix}/${id}/" "$dst" >&2; then
    echo "    ✓ [${i}/${total}] ${id} — done" >&2
    last_dst="$dst"
    succeeded+=("$dst")
  else
    echo "    ✗ [${i}/${total}] ${id} — FAILED" >&2
    failed=$((failed + 1))
  fi
done

if [[ "$failed" -gt 0 ]]; then
  echo "Finished with ${failed}/${total} failed." >&2
else
  echo "All ${total} project(s) synced." >&2
fi

# Decide which folder the caller should cd into and emit it on stdout.
# With several successful syncs, let the user pick (fzf UI runs on the TTY;
# only the chosen path lands on stdout). Esc / no fzf falls back to the last.
chosen="$last_dst"
if [[ ${#succeeded[@]} -gt 1 ]] && command -v fzf >/dev/null 2>&1; then
  picked="$(printf '%s\n' "${succeeded[@]}" \
    | fzf --height 40% --reverse --prompt 'cd into > ' \
          --header 'Select which synced project to cd into (Esc = last)')" || picked=""
  if [[ -n "$picked" ]]; then
    chosen="$picked"
  fi
fi

if [[ -n "$chosen" ]]; then
  printf '%s\n' "$chosen"
fi

# Fail only if nothing synced at all (so a partial batch still cd's).
if [[ "$failed" -eq "$total" ]]; then
  exit 1
fi
exit 0
