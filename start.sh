#!/bin/bash
# 一键启动 runner1-5（后台运行）

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

for i in 1 2 3 4 5; do
  DIR="$BASE_DIR/runner${i}"
  if [ ! -f "$DIR/.runner" ]; then
    echo "runner${i}: not configured, skipping (run ./setup.sh first)"
    continue
  fi

  # 检查是否已在运行
  if [ -f "$DIR/.runner_pid" ]; then
    PID=$(cat "$DIR/.runner_pid")
    if kill -0 "$PID" 2>/dev/null; then
      echo "runner${i}: already running (PID $PID)"
      continue
    fi
  fi

  echo "Starting runner${i}..."
  cd "$DIR"
  nohup ./run.sh > "$DIR/runner.log" 2>&1 &
  echo $! > "$DIR/.runner_pid"
  echo "runner${i}: started (PID $!)"
  cd "$BASE_DIR"
done

echo ""
echo "All runners started. Logs: ~/actions-runner/runner{1..5}/runner.log"
