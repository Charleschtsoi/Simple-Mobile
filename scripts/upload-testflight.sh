#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Point to Xcode 26+ after install, e.g.:
# export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
DEVELOPER_DIR="${DEVELOPER_DIR:-}"
if [[ -n "$DEVELOPER_DIR" ]]; then
  export DEVELOPER_DIR
fi

XCODEBUILD="${DEVELOPER_DIR:+$DEVELOPER_DIR/usr/bin/}xcodebuild"
XCODEBUILD="${XCODEBUILD:-xcodebuild}"

SDK_VERSION="$("$XCODEBUILD" -showsdks 2>/dev/null | grep -E '^\s*iOS ' | tail -1 | sed -E 's/.*-sdk iphoneos([0-9.]+).*/\1/')"
MAJOR_SDK="${SDK_VERSION%%.*}"

if [[ -z "$SDK_VERSION" ]] || [[ "$MAJOR_SDK" -lt 26 ]]; then
  echo "ERROR: App Store Connect requires iOS 26 SDK (Xcode 26+)." >&2
  echo "Current SDK: iphoneos${SDK_VERSION:-unknown}" >&2
  echo "" >&2
  echo "Fix:" >&2
  echo "  1. Update macOS to 15.6+ (System Settings → Software Update)" >&2
  echo "  2. Install Xcode 26 from the Mac App Store" >&2
  echo "  3. sudo xcode-select -s /Applications/Xcode.app/Contents/Developer" >&2
  echo "  4. Re-run this script" >&2
  exit 1
fi

echo "Using SDK: iphoneos${SDK_VERSION}"

TEAM_ID="${DEVELOPMENT_TEAM:-BKJ456P59V}"
ARCHIVE_PATH="$ROOT/build/SimpleMobile.xcarchive"
EXPORT_PATH="$ROOT/build/export"
EXPORT_OPTIONS="$ROOT/ExportOptions.plist"

echo "==> Regenerating Xcode project"
.tools/xcodegen/bin/xcodegen generate

echo "==> Archiving (requires signed-in Xcode Apple ID)"
"$XCODEBUILD" \
  -project SimpleMobile.xcodeproj \
  -scheme SimpleMobile \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE_PATH" \
  archive \
  DEVELOPMENT_TEAM="$TEAM_ID" \
  CODE_SIGN_STYLE=Automatic \
  -allowProvisioningUpdates

echo "==> Exporting IPA for App Store Connect"
rm -rf "$EXPORT_PATH"
"$XCODEBUILD" \
  -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "$EXPORT_OPTIONS" \
  -allowProvisioningUpdates

IPA="$(find "$EXPORT_PATH" -name '*.ipa' | head -1)"
if [[ -z "$IPA" ]]; then
  echo "Export failed: no .ipa found in $EXPORT_PATH" >&2
  exit 1
fi

echo "==> Uploading to App Store Connect / TestFlight"
xcrun altool --upload-app \
  --type ios \
  --file "$IPA" \
  --team-id "$TEAM_ID" \
  --username "${APPLE_ID:?Set APPLE_ID environment variable}" \
  --password "${APPLE_APP_SPECIFIC_PASSWORD:?Set APPLE_APP_SPECIFIC_PASSWORD}"

echo "Done. Check App Store Connect → SimpleMobile → TestFlight for processing status."
