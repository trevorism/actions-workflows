#!/usr/bin/env bash
set -euo pipefail

readonly REQUESTED_VERSION="${1-}"
readonly PROPERTIES_FILE="${2-gradle.properties}"
readonly APP_ENGINE_VERSION_PATTERN='^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$'

fail() {
  echo "$1" >&2
  exit 1
}

read_app_version() {
  local file="$1"
  [ -f "${file}" ] || return 0
  sed -n 's/^[[:space:]]*appVersion[[:space:]]*=[[:space:]]*//p' "${file}" | head -1 | tr -d '[:space:]'
}

version="${REQUESTED_VERSION}"

if [ -z "${version}" ]; then
  semantic_version="$(read_app_version "${PROPERTIES_FILE}")"
  [ -n "${semantic_version}" ] || fail "No version input supplied and no appVersion found in ${PROPERTIES_FILE}"
  version="${semantic_version//./-}"
fi

[[ "${version}" =~ ${APP_ENGINE_VERSION_PATTERN} ]] ||
  fail "Resolved version '${version}' is not a valid App Engine version id. Expected lowercase letters, digits and hyphens, not starting or ending with a hyphen."

printf '%s\n' "${version}"
