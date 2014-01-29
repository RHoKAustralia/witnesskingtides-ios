#!/bin/sh
set -e
export LC_ALL="en_US.UTF-8"

security delete-keychain ios-build.keychain
rm -f ~/Library/MobileDevice/Provisioning\ Profiles/*