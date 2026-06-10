#!/usr/bin/env bash
#
# dispatch-updater-variant.sh — Map a skill name to its updater variant.
#
# Usage:
#   VARIANT=$(bash dispatch-updater-variant.sh <skill-name>)
#
# Prints one of:
#   frontend-async-skill-updater
#   frontend-realtime-skill-updater
#   setup-skill-updater
#   backend-skill-updater
#   infra-skill-updater
#   ai-skill-updater
#
# Exits 1 with an error message if the skill is unknown.

set -euo pipefail

case "${1:-}" in
  velt-comments-best-practices|velt-notifications-best-practices|velt-activity-best-practices|velt-recorder-best-practices|velt-reactions-best-practices|velt-arrows-best-practices|velt-area-best-practices|velt-view-analytics-best-practices)
    echo "frontend-async-skill-updater" ;;
  velt-presence-best-practices|velt-cursors-best-practices|velt-huddle-best-practices|velt-single-editor-mode-best-practices|velt-crdt-best-practices)
    echo "frontend-realtime-skill-updater" ;;
  velt-setup-best-practices)
    echo "setup-skill-updater" ;;
  velt-rest-apis-best-practices|velt-self-hosting-data-best-practices|velt-node-sdk-best-practices)
    echo "backend-skill-updater" ;;
  velt-proxy-server-best-practices|yjs-best-practices)
    echo "infra-skill-updater" ;;
  velt-rewriter-best-practices|velt-approval-engine-best-practices)
    echo "ai-skill-updater" ;;
  "")
    echo "dispatch-updater-variant.sh: skill name required" >&2
    exit 1 ;;
  *)
    echo "dispatch-updater-variant.sh: no updater variant for skill '${1}'" >&2
    echo "Add a new case here when introducing a new skill." >&2
    exit 1 ;;
esac
