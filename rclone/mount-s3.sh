#!/usr/bin/env bash
# Mount the tapvid agent S3 workspaces via rclone (macFUSE).
#
# Tuned for *browsing* (e.g. the nvim Snacks explorer): directory listings are
# cached for a long time so navigating the tree doesn't trigger a cold S3 LIST
# on every open. Because the workspace is written remotely by the agent, new
# files won't appear locally until the cache expires or you force a refresh.
# Each mount runs its own remote-control server on its own port, so refresh with:
#
#     rclone rc --rc-addr 127.0.0.1:5572 vfs/refresh recursive=true   # tapvid-agent
#     rclone rc --rc-addr 127.0.0.1:5573 vfs/refresh recursive=true   # tapvid-agent-prod
#
# Usage:
#     mount-s3.sh            # (re)mount all
#     mount-s3.sh umount     # unmount all

set -euo pipefail

REMOTE="s3"
MNT_BASE="$HOME/mnt/s3"

# bucket / rc-port pairs (path within bucket is /workspace). Each mount needs a
# distinct rc port or the second --rc bind fails with "address already in use".
BUCKETS=(tapvid-agent tapvid-agent-prod)
RC_PORTS=(5572 5573)

unmount_one() {
  local dir="$1"
  if mount | grep -q " on ${dir} "; then
    echo "unmounting ${dir}"
    umount "${dir}" 2>/dev/null || diskutil unmount force "${dir}" 2>/dev/null || true
  fi
}

mount_one() {
  local bucket="$1"
  local port="$2"
  local dir="${MNT_BASE}/${bucket}"
  unmount_one "${dir}"
  mkdir -p "${dir}"
  echo "mounting ${REMOTE}:${bucket}/workspace -> ${dir} (rc on :${port})"
  # Background with nohup rather than --daemon: rclone's --daemon double-forks and
  # the parent + child both try to bind the --rc port, failing with "address
  # already in use". Running in the foreground (backgrounded by the shell) avoids
  # the double bind. --log-file keeps it quiet.
  nohup rclone mount "${REMOTE}:${bucket}/workspace" "${dir}" \
    --read-only \
    --vfs-cache-mode full \
    --vfs-cache-max-size 10G \
    --dir-cache-time 72h \
    --attr-timeout 1h \
    --poll-interval 0 \
    --rc \
    --rc-addr "127.0.0.1:${port}" \
    --rc-no-auth \
    --log-file "${HOME}/mnt/.rclone-${bucket}.log" \
    --log-level INFO </dev/null >/dev/null 2>&1 &
  disown
}

case "${1:-mount}" in
  umount | unmount)
    for b in "${BUCKETS[@]}"; do unmount_one "${MNT_BASE}/${b}"; done
    ;;
  mount)
    for i in "${!BUCKETS[@]}"; do mount_one "${BUCKETS[$i]}" "${RC_PORTS[$i]}"; done
    echo "done. force a fresh listing any time with e.g.:"
    echo "  rclone rc --rc-addr 127.0.0.1:${RC_PORTS[0]} vfs/refresh recursive=true"
    ;;
  *)
    echo "usage: $(basename "$0") [mount|umount]" >&2
    exit 1
    ;;
esac
