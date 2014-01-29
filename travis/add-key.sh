#!/bin/sh
set -e
export LC_ALL="en_US.UTF-8"

security create-keychain -p travis ios-build.keychain
# security import ./scripts/travis/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
# security import ./scripts/travis/dist.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./Provisioning/kt-dist.p12 -k ~/Library/Keychains/ios-build.keychain -P $CERT_PASS -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./Provisioning/*.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/

