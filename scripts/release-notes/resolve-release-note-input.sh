#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib.sh
source "$SCRIPT_DIR/lib.sh"

release_note_url="${CLIENT_PAYLOAD_RELEASE_NOTE_URL:-${INPUT_RELEASE_NOTE_URL:-}}"
note_path="${CLIENT_PAYLOAD_PATH:-${INPUT_PATH:-}}"
note_ref="${CLIENT_PAYLOAD_SHA:-${INPUT_SHA:-}}"
change_type="${CLIENT_PAYLOAD_CHANGE_TYPE:-${INPUT_CHANGE_TYPE:-added}}"
source_repo="${CLIENT_PAYLOAD_SOURCE_REPO:-${INPUT_SOURCE_REPO:-snippyly/internal-release-notes}}"
pipeline_mode="${CLIENT_PAYLOAD_MODE:-${INPUT_MODE:-}}"
pipeline_dry_run="${CLIENT_PAYLOAD_DRY_RUN:-${INPUT_DRY_RUN:-false}}"

if [ -n "$release_note_url" ]; then
  if ! rn_parse_release_note_url "$release_note_url"; then
    echo "::error::Unsupported release_note_url. Use a GitHub blob/raw URL under release-notes/**/*.md." >&2
    exit 1
  fi

  if [ -n "$note_path" ] && [ "$note_path" != "$RN_URL_PATH" ]; then
    echo "::error::Both path and release_note_url were provided, but they resolve to different paths: $note_path vs $RN_URL_PATH" >&2
    exit 1
  fi

  note_path="$RN_URL_PATH"
  source_repo="$RN_URL_REPO"
  if [ -z "$note_ref" ]; then
    note_ref="$RN_URL_REF"
  fi
  if [ -z "$pipeline_mode" ]; then
    pipeline_mode="resume"
  fi
fi

if [ -z "$note_path" ]; then
  echo "::error::Provide either path or release_note_url." >&2
  exit 1
fi

if [ -z "$pipeline_mode" ]; then
  pipeline_mode="auto"
fi

if [[ ! "$change_type" =~ ^(added|modified|renamed|deleted)$ ]]; then
  echo "::error::Unsupported change_type=$change_type" >&2
  exit 1
fi

if [[ ! "$pipeline_mode" =~ ^(auto|resume|force)$ ]]; then
  echo "::error::Unsupported mode=$pipeline_mode" >&2
  exit 1
fi

if [[ ! "$pipeline_dry_run" =~ ^(true|false)$ ]]; then
  echo "::error::Unsupported dry_run=$pipeline_dry_run" >&2
  exit 1
fi

source_note_url="$release_note_url"
if [ -z "$source_note_url" ]; then
  source_note_url="https://github.com/${source_repo}/blob/${note_ref:-main}/${note_path}"
fi

{
  echo "note_path=$note_path"
  echo "note_ref=$note_ref"
  echo "change_type=$change_type"
  echo "source_repo=$source_repo"
  echo "pipeline_mode=$pipeline_mode"
  echo "pipeline_dry_run=$pipeline_dry_run"
  echo "release_note_url=$release_note_url"
  echo "source_note_url=$source_note_url"
} >> "${GITHUB_OUTPUT:-/dev/stdout}"

echo "Resolved note: $source_repo/$note_path @ ${note_ref:-main} ($change_type, mode=$pipeline_mode, dry_run=$pipeline_dry_run)"
