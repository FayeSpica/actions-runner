#!/bin/bash
# 查看所有 runner 状态

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

printf "%-10s %-12s %-8s %s\n" "RUNNER" "STATUS" "PID" "NAME"
printf "%-10s %-12s %-8s %s\n" "------" "------" "---" "----"

for i in 1 2 3 4 5; do
  DIR="$BASE_DIR/runner${i}"
  NAME="-"

  if [ ! -f "$DIR/.runner" ]; then
    printf "%-10s %-12s %-8s %s\n" "runner${i}" "unconfigured" "-" "-"
    continue
  fi

  if [ -f "$DIR/.runner" ]; then
    NAME=$(grep -o '"agentName"[[:space:]]*:[[:space:]]*"[^"]*"' "$DIR/.runner" | sed 's/.*"\([^"]*\)"$/\1/')
    [ -z "$NAME" ] && NAME="-"
  fi

  if [ -f "$DIR/.runner_pid" ]; then
    PID=$(cat "$DIR/.runner_pid")
    if kill -0 "$PID" 2>/dev/null; then
      printf "%-10s %-12s %-8s %s\n" "runner${i}" "running" "$PID" "$NAME"
    else
      printf "%-10s %-12s %-8s %s\n" "runner${i}" "stopped" "-" "$NAME"
    fi
  else
    printf "%-10s %-12s %-8s %s\n" "runner${i}" "stopped" "-" "$NAME"
  fi
done
