#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/w/OCCoding"
BRANCH="main"
REMOTE="origin"

cd "$REPO_DIR"

if [ ! -d .git ]; then
  echo "Not a git repo: $REPO_DIR" >&2
  exit 1
fi

# Track current workspace files, but avoid forcing ignored runtime junk.
git add -A

if git diff --cached --quiet; then
  echo "No changes to commit"
  exit 0
fi

TS="$(TZ=Asia/Shanghai date '+%Y-%m-%d %H:%M:%S %Z')"
HOST="$(hostname)"

git commit -m "chore: auto backup ${TS} @ ${HOST}"
git push "$REMOTE" "$BRANCH"

echo "Backup pushed successfully"
