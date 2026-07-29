#!/usr/bin/env bash

# Shared helpers for the release-note automation. This file is sourced by
# scripts and tests; keep it side-effect free.

rn_slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | tr -cs 'a-z0-9._-' '-' \
    | sed -E 's/^-+//; s/-+$//; s/-+/-/g'
}

rn_version_major() {
  local version="$1"
  printf '%s' "$version" | sed -E 's/^v?([0-9]+).*/\1/'
}

rn_init_route() {
  RN_CLASS=""
  RN_VERSION=""
  RN_STEM=""
  RN_SAFE_STEM=""
  RN_BRANCH=""
  RN_TITLE=""
  RN_CHANGELOG=""
  RN_MAJOR=""
  RN_TRIAGE_REASON=""
}

rn_classify_path() {
  local note_path="${1:?note path is required}"
  local filename stem version major

  rn_init_route

  filename="${note_path##*/}"
  stem="${filename%.md}"
  RN_STEM="$stem"
  RN_SAFE_STEM="$(rn_slugify "$stem")"

  if [[ ! "$note_path" =~ ^release-notes/.+\.md$ ]]; then
    RN_CLASS="unknown"
    RN_BRANCH="release-note-unknown-${RN_SAFE_STEM}"
    RN_TITLE="[needs triage] ${RN_STEM}"
    RN_TRIAGE_REASON="path is outside release-notes/**/*.md"
    return 0
  fi

  if [[ "$note_path" =~ ^release-notes/velt-py-sdk/v[^/]+\.md$ ]]; then
    version="$stem"
    RN_CLASS="velt-py"
    RN_VERSION="$version"
    RN_BRANCH="velt-py-${version}"
    RN_TITLE="velt-py-${version}"
    RN_CHANGELOG="release-notes/version-5/velt-py-changelog.mdx"
    return 0
  fi

  if [[ "$note_path" =~ ^release-notes/velt-node-sdk/v[^/]+\.md$ ]]; then
    version="$stem"
    RN_CLASS="velt-node"
    RN_VERSION="$version"
    RN_BRANCH="velt-node-docs-${version}"
    RN_TITLE="velt-node-${version}"
    RN_CHANGELOG="release-notes/version-5/velt-node-changelog.mdx"
    return 0
  fi

  if [[ "$note_path" =~ ^release-notes/shared-firebase-function-.+\.md$ ]]; then
    RN_CLASS="firebase"
    RN_VERSION="$stem"
    RN_TITLE="shared-firebase-function ${stem}"
    return 0
  fi

  if [[ "$note_path" =~ ^release-notes/v[^/]+\.md$ ]]; then
    version="$stem"
    major="$(rn_version_major "$version")"
    RN_CLASS="core-SDK"
    RN_VERSION="$version"
    RN_MAJOR="$major"
    RN_BRANCH="$version"
    RN_TITLE="$version"
    RN_CHANGELOG="release-notes/version-${major}/sdk-changelog.mdx"
    return 0
  fi

  RN_CLASS="unknown"
  RN_BRANCH="release-note-unknown-${RN_SAFE_STEM}"
  RN_TITLE="[needs triage] ${RN_STEM}"
  RN_TRIAGE_REASON="no deterministic route exists for this release-note path"
}

rn_summary_class_hint() {
  local note_file="${1:?note file is required}"
  local summary="" line count=0

  while IFS= read -r line || [ -n "$line" ]; do
    if rn_is_internal_header_line "$line"; then
      break
    fi
    summary="${summary}${line}
"
    count=$((count + 1))
    if [ "$count" -ge 80 ]; then
      break
    fi
  done < "$note_file"

  if printf '%s\n' "$summary" | rg -i 'shared-firebase-function' >/dev/null 2>&1; then
    printf 'firebase'
    return 0
  fi
  if printf '%s\n' "$summary" | rg -i '(@veltdev/node|velt-node)' >/dev/null 2>&1; then
    printf 'velt-node'
    return 0
  fi
  if printf '%s\n' "$summary" | rg -i 'velt-py' >/dev/null 2>&1; then
    printf 'velt-py'
    return 0
  fi
  if printf '%s\n' "$summary" | rg -i '(HTML/Vanilla \(sdk\)|React \(sdk-react\)|core SDK|Javascript SDK|JavaScript SDK)' >/dev/null 2>&1; then
    printf 'core-SDK'
    return 0
  fi
}

rn_validate_summary_hint() {
  local note_file="${1:?note file is required}"
  local hint

  hint="$(rn_summary_class_hint "$note_file" || true)"
  if [ -z "$hint" ] || [ "$RN_CLASS" = "unknown" ]; then
    return 0
  fi
  if [ "$hint" != "$RN_CLASS" ]; then
    RN_TRIAGE_REASON="path route (${RN_CLASS}) conflicts with source-note summary hint (${hint})"
    RN_CLASS="unknown"
    RN_BRANCH="release-note-unknown-${RN_SAFE_STEM}"
    RN_TITLE="[needs triage] ${RN_STEM}"
    RN_CHANGELOG=""
    return 1
  fi
  return 0
}

rn_route_json() {
  jq -n \
    --arg class "$RN_CLASS" \
    --arg version "$RN_VERSION" \
    --arg stem "$RN_STEM" \
    --arg safe_stem "$RN_SAFE_STEM" \
    --arg branch "$RN_BRANCH" \
    --arg title "$RN_TITLE" \
    --arg changelog "$RN_CHANGELOG" \
    --arg major "$RN_MAJOR" \
    --arg triage_reason "$RN_TRIAGE_REASON" \
    '{
      class: $class,
      version: $version,
      stem: $stem,
      safe_stem: $safe_stem,
      branch: $branch,
      title: $title,
      changelog: $changelog,
      major: $major,
      triage_reason: $triage_reason
    }'
}

rn_slack_pr_payload() {
  local pr_url="${1:?pr url is required}"
  local pr_number="${2:?pr number is required}"
  local pr_title="${3:?pr title is required}"
  local note_path="${4:?note path is required}"
  local route="${5:?route is required}"
  local source_url="${6:?source url is required}"
  local run_url="${7:-}"
  local status="${8:-In progress}"
  local run_text="not provided"

  if [ -n "$run_url" ]; then
    run_text="<$run_url|GitHub Actions run>"
  fi

  jq -n \
    --arg pr_url "$pr_url" \
    --arg pr_number "$pr_number" \
    --arg pr_title "$pr_title" \
    --arg note_path "$note_path" \
    --arg route "$route" \
    --arg source_url "$source_url" \
    --arg run_text "$run_text" \
    --arg status "$status" \
    '{
      text: "Release-note docs PR created: #\($pr_number) \($pr_title)",
      blocks: [
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: "*Release-note docs PR created*\n<\($pr_url)|#\($pr_number) \($pr_title)>"
          }
        },
        {
          type: "section",
          fields: [
            {
              type: "mrkdwn",
              text: "*Release note:*\n`\($note_path)`"
            },
            {
              type: "mrkdwn",
              text: "*Route:*\n`\($route)`"
            },
            {
              type: "mrkdwn",
              text: "*Source:*\n<\($source_url)|release note>"
            },
            {
              type: "mrkdwn",
              text: "*Run:*\n\($run_text)"
            },
            {
              type: "mrkdwn",
              text: "*Status:*\n\($status)"
            }
          ]
        }
      ]
    }'
}

rn_is_core_release_branch() {
  local branch="${1:?branch is required}"
  [[ "$branch" =~ ^v[0-9] ]]
}

rn_parse_release_note_url() {
  local url="${1:?release note URL is required}"
  local cleaned rest owner repo tail ref path

  RN_URL_REPO=""
  RN_URL_REF=""
  RN_URL_PATH=""

  cleaned="${url%%#*}"
  cleaned="${cleaned%%\?*}"

  if [[ "$cleaned" =~ ^https://github\.com/[^/]+/[^/]+/blob/.+/release-notes/.+\.md$ ]]; then
    rest="${cleaned#https://github.com/}"
    owner="${rest%%/*}"
    rest="${rest#*/}"
    repo="${rest%%/*}"
    tail="${rest#*/blob/}"
    ref="${tail%%/release-notes/*}"
    path="release-notes/${tail#*/release-notes/}"
  elif [[ "$cleaned" =~ ^https://raw\.githubusercontent\.com/[^/]+/[^/]+/.+/release-notes/.+\.md$ ]]; then
    rest="${cleaned#https://raw.githubusercontent.com/}"
    owner="${rest%%/*}"
    rest="${rest#*/}"
    repo="${rest%%/*}"
    tail="${rest#*/}"
    ref="${tail%%/release-notes/*}"
    path="release-notes/${tail#*/release-notes/}"
  else
    return 1
  fi

  if [ -z "$owner" ] || [ -z "$repo" ] || [ -z "$ref" ] || [ -z "$path" ]; then
    return 1
  fi

  RN_URL_REPO="${owner}/${repo}"
  RN_URL_REF="$ref"
  RN_URL_PATH="$path"
}

rn_is_internal_header_line() {
  local line="${1:-}"
  local normalized

  normalized="$(printf '%s' "$line" \
    | sed -E 's/\r$//; s/^[[:space:]]+//; s/[[:space:]]+$//; s/^#{1,6}[[:space:]]*//; s/[[:space:]]*#+[[:space:]]*$//; s/^[*_`]+//; s/[*_`]+$//' \
    | tr '[:upper:]' '[:lower:]')"

  case "$normalized" in
    internal|internal:|internal-context|internal-context:|"internal context"|"internal context:"|"for internal use"|"for internal use:")
      return 0
      ;;
  esac

  return 1
}

rn_write_public_note() {
  local source_file="${1:?source file is required}"
  local output_file="${2:?output file is required}"
  local trimmed_marker="${3:-}"
  local line trimmed="false"

  : > "$output_file"

  while IFS= read -r line || [ -n "$line" ]; do
    if rn_is_internal_header_line "$line"; then
      trimmed="true"
      break
    fi
    printf '%s\n' "$line" >> "$output_file"
  done < "$source_file"

  awk '{ lines[NR]=$0; if ($0 ~ /[^[:space:]]/) last=NR } END { for (i=1; i<=last; i++) print lines[i] }' "$output_file" > "${output_file}.tmp"
  mv "${output_file}.tmp" "$output_file"

  if [ ! -s "$output_file" ]; then
    echo "rn_write_public_note: no public release-note content remains after internal section trimming" >&2
    return 1
  fi

  if [ -n "$trimmed_marker" ]; then
    if [ "$trimmed" = "true" ]; then
      printf 'trimmed_internal_section=true\n' > "$trimmed_marker"
    else
      printf 'trimmed_internal_section=false\n' > "$trimmed_marker"
    fi
  fi
}
