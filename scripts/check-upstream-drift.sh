#!/usr/bin/env bash
# Read-only upstream drift check for the MareoX ego-lite fork.
#
# This script fetches refs from the upstream project and reports whether the
# upstream branch, latest tag, or skills/ego-browser tree differs. It does not
# merge, rebase, push, reset, checkout, or modify the reviewed agent-config
# skill. A detected difference is a review trigger, not an update action.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
STATE_DIR="${EGO_LITE_STATE_DIR:-$HOME/.local/state/ego-lite}"
STATE_FILE="$STATE_DIR/upstream-drift-state"
LOCK_DIR="$STATE_DIR/.upstream-drift.lock"

umask 077
mkdir -p "$STATE_DIR"
chmod 700 "$STATE_DIR"

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  printf 'ego-lite upstream drift check already running\n' >&2
  exit 0
fi
trap 'rmdir "$LOCK_DIR"' EXIT

git -C "$REPO_DIR" remote get-url upstream >/dev/null
git -C "$REPO_DIR" fetch --quiet upstream --tags --prune

FORK_REF="${EGO_LITE_FORK_REF:-origin/main}"
UPSTREAM_REF="${EGO_LITE_UPSTREAM_REF:-upstream/main}"
git -C "$REPO_DIR" rev-parse --verify "$FORK_REF" >/dev/null
git -C "$REPO_DIR" rev-parse --verify "$UPSTREAM_REF" >/dev/null

read -r FORK_AHEAD UPSTREAM_AHEAD <<EOF
$(git -C "$REPO_DIR" rev-list --left-right --count "$FORK_REF...$UPSTREAM_REF")
EOF

UPSTREAM_COMMIT="$(git -C "$REPO_DIR" rev-parse "$UPSTREAM_REF")"
LATEST_TAG="$(git -C "$REPO_DIR" tag --merged "$UPSTREAM_REF" --sort=-v:refname | sed -n '1p')"
if git -C "$REPO_DIR" diff --quiet "$FORK_REF...$UPSTREAM_REF" -- skills/ego-browser; then
  SKILL_DIFF=no
else
  SKILL_DIFF=yes
fi

STATE="upstream_commit=$UPSTREAM_COMMIT latest_tag=${LATEST_TAG:-none} fork_ahead=$FORK_AHEAD upstream_ahead=$UPSTREAM_AHEAD skill_diff=$SKILL_DIFF"
PREVIOUS_STATE="$(test -f "$STATE_FILE" && cat "$STATE_FILE" || true)"
printf '%s\n' "$STATE" >"$STATE_FILE"

if [ "$STATE" != "$PREVIOUS_STATE" ]; then
  printf 'REVIEW_REQUIRED %s\n' "$STATE"
else
  printf 'NO_CHANGE %s\n' "$STATE"
fi
