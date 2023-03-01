#!/bin/bash

####################################################################################################
# How to run:
#
# cp scripts/.env.template scripts/.env
# # Fill scripts/.env.template
# source scripts/.env
# ./scripts/distribute.sh
####################################################################################################

set -e
set -o xtrace

cd "$(dirname "$0")"
cd ..

OUTPUT_DIR="output"
ARCHIVE_PATH="$OUTPUT_DIR/archive.xcarchive"

[[ -d "$OUTPUT_DIR" ]] && rm -rf "$OUTPUT_DIR"
[[ -d tmp_derived_data ]] && rm -rf "tmp_derived_data"
[[ -f release.zip ]] && rm release.zip

xcodebuild archive -scheme PlaygroundQLPreviewProvider \
	-archivePath "$ARCHIVE_PATH" \
	-destination "generic/platform=macOS" \
	-derivedDataPath "tmp_derived_data"

xcodebuild -exportArchive \
	-archivePath "$ARCHIVE_PATH" \
	-exportOptionsPlist "scripts/exportOptions.plist" \
	-allowProvisioningUpdates \
	-authenticationKeyIssuerID "$API_KEY_ISSUER" \
	-authenticationKeyID "$API_KEY_ID" \
	-authenticationKeyPath "$API_KEY_PATH" \
	-exportPath "$OUTPUT_DIR"

GENERATED_APP="$OUTPUT_DIR/PlaygroundQLPreviewProvider.app"

cp -r "$GENERATED_APP" "$GENERATED_APP.backup"

pushd "$OUTPUT_DIR"
zip -r "PlaygroundQLPreviewProvider-notarize.zip" PlaygroundQLPreviewProvider.app
popd

xcrun notarytool submit "$OUTPUT_DIR/PlaygroundQLPreviewProvider-notarize.zip" \
	--key $API_KEY_PATH \
	--key-id $API_KEY_ID \
	--issuer $API_KEY_ISSUER \
	--wait
xcrun stapler staple "$GENERATED_APP"

pushd "$OUTPUT_DIR"
zip -r "../release.zip" PlaygroundQLPreviewProvider.app
popd

echo 'SUCCESSFUL Release !'
echo 'The app is present in "release.zip"'
