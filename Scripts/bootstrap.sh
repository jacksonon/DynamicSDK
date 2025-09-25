#!/bin/bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$REPO_ROOT"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "❌ XcodeGen is required. Install it via 'brew install xcodegen'." >&2
  exit 1
fi

xcodegen generate

if ! command -v bundle >/dev/null 2>&1; then
  echo "❌ Bundler is required. Install it via 'gem install bundler'." >&2
  exit 1
fi

bundle install --path vendor/bundle
bundle exec pod install --project-directory="$REPO_ROOT"
