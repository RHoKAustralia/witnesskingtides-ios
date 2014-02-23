#!/bin/sh

if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi
if [[ "$TRAVIS_BRANCH" != "master" ]]; then
  echo "Testing on a branch other than master. No deployment will be done."
  exit 0
fi

# Thanks @djacobs https://gist.github.com/djacobs/2411095
xctool -workspace KingTides.xcworkspace -scheme KingTides -configuration Release build

APPNAME=KingTides
PROVISIONING_PROFILE="./Provisioning/KingTides_Ad_Hoc.mobileprovision"
RELEASE_DATE=`date '+%Y-%m-%d %H:%M:%S'`
OUTPUTDIR=`xctool -workspace $APPNAME.xcworkspace -scheme $APPNAME -showBuildSettings | grep ' BUILT_PRODUCTS_DIR ' | awk '{ print $3 }'`

echo "********************"
echo "*     Signing      *"
echo "********************"
xcrun -log -sdk iphoneos PackageApplication "$OUTPUTDIR/$APPNAME.app" -o "$OUTPUTDIR/$APPNAME.ipa" -sign "iPhone Distribution" -embed "$PROVISIONING_PROFILE"

RELEASE_NOTES="Build: $TRAVIS_BUILD_NUMBER\nUploaded: $RELEASE_DATE"

zip -r -9 "$OUTPUTDIR/$APPNAME.app.dSYM.zip" "$OUTPUTDIR/$APPNAME.app.dSYM"

echo "********************"
echo "*    Uploading     *"
echo "********************"
curl http://testflightapp.com/api/builds.json \
  -F file="@$OUTPUTDIR/$APPNAME.ipa" \
  -F dsym="@$OUTPUTDIR/$APPNAME.app.dSYM.zip" \
  -F api_token="$API_TOKEN" \
  -F team_token="$TEAM_TOKEN" \
  -F distribution_lists='Internal' \
  -F notify='true'
  -F notes="$RELEASE_NOTES" -v
