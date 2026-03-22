#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/w/OCCoding"
BRANCH="main"
REMOTE="origin"

# Conservative backup policy: only these paths are tracked.
INCLUDE_PATHS=(
  "AGENTS.md"
  "HEARTBEAT.md"
  "IDENTITY.md"
  "MEMORY.md"
  "SOUL.md"
  "TOOLS.md"
  "USER.md"
  ".gitignore"
  "bridge"
  "memory"
  ".openclaw/workspace-state.json"
  "scripts/auto-backup.sh"
)

cd "$REPO_DIR"

if [ ! -d .git ]; then
  echo "Not a git repo: $REPO_DIR" >&2
  exit 1
fi

# Reset index view first so only the whitelist participates in this backup run.
git reset -q HEAD -- . >/dev/null 2>&1 || true

ADD_ARGS=()
for path in "${INCLUDE_PATHS[@]}"; do
  if [ -e "$path" ]; then
    ADD_ARGS+=("$path")
  fi
done

if [ ${#ADD_ARGS[@]} -eq 0 ]; then
  echo "No whitelisted paths found"
  exit 1
fi

git add -A -- "${ADD_ARGS[@]}"

if git diff --cached --quiet; then
  echo "No changes to commit"
  exit 0
fi

TS="$(TZ=Asia/Shanghai date '+%Y-%m-%d %H:%M:%S %Z')"
HOST="$(hostname)"

git commit -m "chore: auto backup ${TS} @ ${HOST}"
git push "$REMOTE" "$BRANCH"

echo "Backup pushed successfully"
