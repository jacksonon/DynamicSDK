#!/bin/bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$REPO_ROOT"

./Scripts/bootstrap.sh

WORKSPACE="DynamicSDK.xcworkspace"
SCHEME="DynamicSDK"
CONFIGURATION="Release"
ARCHIVE_ROOT="$REPO_ROOT/build"
OUTPUT_DIR="$REPO_ROOT/BuildArtifacts"

rm -rf "$ARCHIVE_ROOT" "$OUTPUT_DIR"
mkdir -p "$ARCHIVE_ROOT" "$OUTPUT_DIR"

DEVICE_ARCHIVE="$ARCHIVE_ROOT/ios.xcarchive"
SIMULATOR_ARCHIVE="$ARCHIVE_ROOT/simulator.xcarchive"

xcodebuild archive \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk iphoneos \
  -destination "generic/platform=iOS" \
  -archivePath "$DEVICE_ARCHIVE" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -sdk iphonesimulator \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$SIMULATOR_ARCHIVE" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework \
  -framework "$DEVICE_ARCHIVE/Products/Library/Frameworks/DynamicSDK.framework" \
  -framework "$SIMULATOR_ARCHIVE/Products/Library/Frameworks/DynamicSDK.framework" \
  -output "$OUTPUT_DIR/DynamicSDK.xcframework"

echo "✅ XCFramework generated at $OUTPUT_DIR/DynamicSDK.xcframework"
