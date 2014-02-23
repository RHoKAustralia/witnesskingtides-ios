[![Build Status](https://travis-ci.org/rhok-melbourne/witnesskingtides-ios.png?branch=master)](https://travis-ci.org/rhok-melbourne/witnesskingtides-ios)

witnesskingtides-ios
==============

Installation
------------
The WitnessKingTides build requires XCode 5+ and ruby 2.0.x with bundler (http://gembundler.com/).
````
bundle install
````
open the WitnessKingTides workspace: `WitnessKingTides/WitnessKingTides.xcworkspace` in XCode / AppCode

Building
--------
Command line builds are done using xctool
````
brew install xctool
````

### To build:
From the command line
xctool -workspace KingTides.xcworkspace -scheme KingTides -configuration Release build

````
### To run unit tests:
````
xctool -workspace KingTides.xcworkspace -scheme KingTides -configuration Debug test -sdk iphonesimulator
````
### To upload to testflight:
````
travis/testflight.sh
````

