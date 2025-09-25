#!/bin/bash
set -euo pipefail

if [[ -z "${PODS_ROOT:-}" || -z "${TARGET_BUILD_DIR:-}" || -z "${PUBLIC_HEADERS_FOLDER_PATH:-}" ]]; then
  echo "copy_third_party_headers.sh: required environment variables are missing" >&2
  exit 0
fi

function sync_headers() {
  local source_dir="$1"
  local dest_dir="$2"

  if [[ -d "$source_dir" ]]; then
    mkdir -p "$dest_dir"
    rsync -a --delete "$source_dir/" "$dest_dir/"
  fi
}

HEADERS_DEST="${TARGET_BUILD_DIR}/${PUBLIC_HEADERS_FOLDER_PATH}"

sync_headers "${PODS_ROOT}/Headers/Public/AFNetworking" "${HEADERS_DEST}/AFNetworking"
sync_headers "${PODS_ROOT}/Headers/Public/SDWebImage" "${HEADERS_DEST}/SDWebImage"
