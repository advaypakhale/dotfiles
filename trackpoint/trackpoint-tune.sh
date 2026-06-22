#!/usr/bin/env bash
set -euo pipefail

SENS=132
SPEED=158
INERTIA=6

node=""
for c in $(find /sys/devices -type d -name 'serio*' 2>/dev/null); do
  if [ -w "$c/sensitivity" ] && [ -w "$c/speed" ]; then node="$c"; break; fi
done
[ -n "$node" ] || { echo "trackpoint serio node not found" >&2; exit 1; }

echo "$SENS"    > "$node/sensitivity"
echo "$SPEED"   > "$node/speed"
echo "$INERTIA" > "$node/inertia"
