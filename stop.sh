#!/bin/bash
# 停止所有 runner

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

for i in 1 2 3 4 5; do
  DIR="$BASE_DIR/runner${i}"
  if [ -f "$DIR/.runner_pid" ]; then
    PID=$(cat "$DIR/.runner_pid")
    if kill -0 "$PID" 2>/dev/null; then
      kill "$PID"
      echo "runner${i}: stopped (PID $PID)"
    else
      echo "runner${i}: not running"
    fi
    rm -f "$DIR/.runner_pid"
  else
    echo "runner${i}: no pid file"
  fi
done
