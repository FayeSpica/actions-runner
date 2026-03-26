#!/bin/bash
# Usage: ./setup.sh <GITHUB_TOKEN>
# 初始化 runner1-5，每个 runner 独立目录

set -e

TOKEN=$1
REPO_URL="https://github.com/faye-wan-ai/chat-bi-ai-poc"
RUNNER_VERSION="2.322.0"
RUNNER_TAR="actions-runner-osx-arm64-${RUNNER_VERSION}.tar.gz"
RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_TAR}"
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$TOKEN" ]; then
  echo "Usage: $0 <GITHUB_RUNNER_TOKEN>"
  echo "Get token from: Settings → Actions → Runners → New self-hosted runner"
  exit 1
fi

# 下载 runner（只下一次）
if [ ! -f "$BASE_DIR/$RUNNER_TAR" ]; then
  echo "Downloading runner v${RUNNER_VERSION}..."
  curl -sL -o "$BASE_DIR/$RUNNER_TAR" "$RUNNER_URL"
fi

for i in 1 2 3 4 5; do
  DIR="$BASE_DIR/runner${i}"
  if [ -f "$DIR/.runner" ]; then
    echo "runner${i}: already configured, skipping"
    continue
  fi

  echo "Setting up runner${i}..."
  mkdir -p "$DIR"
  tar xzf "$BASE_DIR/$RUNNER_TAR" -C "$DIR"
  cd "$DIR"
  ./config.sh --url "$REPO_URL" --token "$TOKEN" --name "runner-${i}" --unattended --replace
  cd "$BASE_DIR"
  echo "runner${i}: configured"
done

echo ""
echo "All runners configured. Run ./start.sh to start all runners."
