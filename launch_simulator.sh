#!/bin/bash

open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app;
brew update;
brew install libimobiledevice;
brew install ideviceinstaller;
brew install ios-deploy;
brew install cocoapods || echo 'ignore exit(1)';
brew link --overwrite cocoapods;
git clone https://github.com/flutter/flutter.git;
export PATH="$PATH":"$HOME/.pub-cache/bin";
export PATH=`pwd`/flutter/bin:`pwd`/flutter/bin/cache/dart-sdk/bin:$PATH;
flutter precache;
flutter doctor -v;
flutter devices;