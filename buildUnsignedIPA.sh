#!/bin/sh

# Cleanup
rm -rf build
rm -rf Payload

# Build unsigned archive
/usr/bin/xcodebuild -scheme Cloudy -workspace Cloudy.xcworkspace/ -configuration Release clean archive -archivePath "build/Cloudy.xcarchive" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO

# Check not signed
codesign -dv build/Cloudy.xcarchive/Products/Applications/Cloudy.app

# Create payload 
mkdir Payload
mv build/Cloudy.xcarchive/Products/Applications/Cloudy.app Payload/Cloudy.app

# Get version
VERSION=$(xcodebuild -showBuildSettings | grep MARKETING_VERSION | tr -d 'MARKETING_VERSION =')
BUILD=$(xcodebuild -showBuildSettings | grep CURRENT_PROJECT_VERSION | tr -d 'CURRENT_PROJECT_VERSION =')

# Zip file
zip -r "Cloudy-v$VERSION($BUILD).ipa" Payload

# Cleanup
rm -rf build
rm -rf Payload
