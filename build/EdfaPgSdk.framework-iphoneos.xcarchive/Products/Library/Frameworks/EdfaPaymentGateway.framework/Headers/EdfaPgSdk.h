//
//  EdfaPgSdk.h
//  EdfaPgSdk
//
//  Created by Zohaib Kambrani on 26/01/2023.
// To Archive the Framework (xcodebuild archive)
// To Clean/Build/Arvice the Framework  (xcodebuild -project EdfaPgSdk.xcodeproj -scheme EdfaPgSdk -configuration Release CONFIGURATION_BUILD_DIR=. clean build)


/*
// Could not find module 'EdfaPgSdk' for target 'arm64-apple-ios-simulator'; found: arm64-apple-ios, at: /Volumes/EdfaPay/Codes/Github/EdfaPg/iOS/expresspay-ios-sdk-framework/EdfaPgSdk.framework/Modules/EdfaPgSdk.swiftmodule


// Archive Framework for Simulator
xcodebuild archive \
-scheme EdfaPgSdk \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/EdfaPgSdk.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
MARKETING_VERSION=0.0.6 \
CURRENT_PROJECT_VERSION=0.0.6


// Archive Framework for iOS
xcodebuild archive \
-scheme EdfaPgSdk \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/EdfaPgSdk.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
MARKETING_VERSION=0.0.7 \
CURRENT_PROJECT_VERSION=0.0.7

*/

#import <Foundation/Foundation.h>

//! Project version number for EdfaPgSdk.
FOUNDATION_EXPORT double EdfaPgSdkVersionNumber = 2;

//! Project version string for EdfaPgSdk.
FOUNDATION_EXPORT const unsigned char EdfaPgSdkVersionString[];

// In this header, you should import all the public headers of your framework using statements like



