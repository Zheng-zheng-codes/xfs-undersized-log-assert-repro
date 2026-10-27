#!/bin/sh
set -eu
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
KERNEL=${KERNEL:-7.3}
SCRIPT=${REPLAY_SCRIPT:-/workspace/scripts/replay-kernsight-prog.sh}
OUT=${OUT:-/workspace/validation/ksval-out/replay-7.3-xfs-mounts}
port=${PORT:-12231}
for f in "$HERE"/mount-*.prog; do
  n=$(basename "$f" .prog)
  docker exec kernsight bash "$SCRIPT" "$KERNEL" "/tmp/$n.prog" "$port" "$OUT/$n" "xfsm-$n" || true
  port=$((port+1))
done
