#!/bin/bash
echo -e "PID\t\tSWAP\t\tCOMMAND"
for DIR in /proc/[0-9]*; do
  PID=$(basename $DIR)
  SWAP=$(awk '/VmSwap/{print $2}' $DIR/status 2>/dev/null)
  CMD=$(tr -d '\0' < $DIR/cmdline 2>/dev/null | cut -c1-50)
  if [ ! -z "$SWAP" ] && [ "$SWAP" -ne 0 ]; then
    echo -e "$PID\t\t$SWAP\t\t$CMD"
  fi
done | sort -k2 -n -r
