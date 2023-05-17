#!/bin/bash
bs=$(tput bold)
be=$(tput sgr0)
black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
orange='\033[0;33m'

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

flutter_sdk_path="/Volumes/EdfaPay/Codes/Github/ExpressPay/Flutter/expresspay-flutter-sdk"
ios_sample_proj_path="/Volumes/EdfaPay/Codes/Github/ExpressPay/iOS/expresspay-ios-sdk-framework"


if [ $# -eq 0 ]; then
    echo -e "${red}${bs}No mandatory argument 'version number' supplied to the script"
    echo -e "${green}[Usage1] ./PrepareForDevice.sh 0.0.1 ${bs}(Build for iOS Device)${be}${black}"
    echo -e "${green}[Usage2] ./PrepareForDevice.sh 0.0.1 sim ${bs}(Build for iOS Simulator)${be}${black}"
    exit 0
fi


if [ $2 == "sim" ];then
    platform="generic/platform=iOS Simulator"
    file_archive="./build/ExpressPaySDK.framework-iphone-simulator.xcarchive"
    file_framework="$file_archive/Products/Library/Frameworks/ExpressPaySDK.framework"
else
    platform="generic/platform=iOS"
    file_archive="./build/ExpressPaySDK.framework-iphone-os.xcarchive"
    file_framework="$file_archive/Products/Library/Frameworks/ExpressPaySDK.framework"
fi




##########################################################
## Build Framework
##########################################################
buildFramework (){
    xcodebuild archive \
        -scheme ExpressPaySDK \
        -configuration Release \
        -destination "$platform" \
        -archivePath $file_archive \
        SKIP_INSTALL=NO \
        BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
        MARKETING_VERSION=$1 \
        CURRENT_PROJECT_VERSION=$1
}




##########################################################
## Copy update/generated framework to the flutter plugin
##########################################################
copyToFlutterPlugin (){
    echo -e "\n\n"
    echo -e "${bs}Whould you like to Copying generated framework to the flutter plugin?${be}"
    echo -e "--> /Volumes/EdfaPay/Codes/Github/ExpressPay/Flutter/expresspay-flutter-sdk/ios"
    read -n1 -p "(y/n)? " ans

    if [ $ans == "y" ] || [ $ans == "Y" ];then
        cp -R $file_framework $flutter_sdk_path/ios/
        echo -e "\b${green}${bs}** Copied to -->${be} /Volumes/EdfaPay/Codes/Github/ExpressPay/Flutter/expresspay-flutter-sdk/ios/${black}"
    fi

}




######################################################
## Publish flutter plugin with upgraded ios framework
######################################################
publishFlutterPlugin (){
    p=$PWD
    
    echo -e "\n\n"
    echo -e "${bs}Whould you like to publish the flutter plugin to pub.dev?${be}"
    echo -e "--> $flutter_sdk_path"
    read -n1 -p "(y/n)? " ans

    if [ $ans == "y" ] || [ $ans == "Y" ];then
        cp -R $file_framework $flutter_sdk_path/ios/ # Copy the ios framework to flutter sdk ios
        cd $flutter_sdk_path
        v=`grep -m1 '^version: ' pubspec.yaml` #(GREP the first line of starts with version:)
        echo -e "\b\n"
        echo -e "${bs}Current flutter plugin ${green}$v${black}"
        read -p "${bs}Enter new version: " ans
        
        v="${v/\+/\\+}" # Replace(+ to \+)  if exist to add escape in string
        perl -i -pe "s/$v/'version: $ans'/e" pubspec.yaml  #(Replace the line)
        v=`grep -m1 '^version: ' pubspec.yaml`  #(GREP the first line of starts with version:)
        echo -e "${bs}Flutter plugin version changed: ${green}$v${black}" #(printing the line from GREP result in variable 'v')
                
        read -p "${bs}Please confirm: (y/n) " ans
        if [ $ans == "y" ] || [ $ans == "Y" ];then
            flutter pub publish --force
        fi
    fi
    
    cd $p
}




####################################################################
## Copy update/generated framework to the ExpressPay Sample project
####################################################################
copyToIosSamplePlugin (){
    echo -e "${black}\n"
    echo -e "${bs}Whould you like to Copying generated framework to the ExpressPay Sample project?${be}"
    echo -e "--> /Volumes/EdfaPay/Codes/Github/ExpressPay/iOS/expresspay-ios-sdk-framework"
    read -n1 -p "(y/n)? " ans

    if [ $ans == "y" ] || [ $ans == "Y" ];then
        cp -R $file_framework $ios_sample_proj_path
        echo -e "\b${green}${bs}** Copied to -->${be} /Volumes/EdfaPay/Codes/Github/ExpressPay/iOS/expresspay-ios-sdk-framework/${black}"
    fi
}




###########################################
## Open the generated framework in 'Finder
###########################################
openInFinder (){
    echo -e "\n\n"
    echo -e "${bs}Whould you like to open the generated framework in 'Finder'${be}"
    read -n1 -p "(y/n)? " ans

    if [ $ans == "y" ] || [ $ans == "Y" ];then
        open $file_archive/Products/Library/Frameworks/
        echo -e "\b${green}${bs}** Opened in finder -->${be} $file_archive/Products/Library/Frameworks/ ${black}"
        echo -e "\n\n"
    fi
}

buildFramework
copyToFlutterPlugin
publishFlutterPlugin
copyToIosSamplePlugin
openInFinder
















