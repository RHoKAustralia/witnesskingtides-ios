security create-keychain -p travis ios-build.keychain
security default-keychain -s ios-build.keychain
security unlock-keychain -p travis ios-build.keychain
security -v set-keychain-settings -lut 86400 ios-build.keychain
security import ./Provisioning/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./Provisioning/dist.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./Provisioning/kt-dist.p12 -k ~/Library/Keychains/ios-build.keychain -P $CERT_PASS -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./Provisioning/*.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
