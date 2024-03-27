#!/bin/bash
clear
export AIR_NOANDROIDFLAIR=true


################################
export AIRPATH="/Users/fluocode/Documents/AIRSDK"
export NAME='NativeDialogs'
export SWFVERSION=10
################################

export ADT="/bin/adt"
export ADT=$AIRPATH$ADT  
#xattr -d com.apple.quarantine "$AIRPATH/runtimes/air/mac/Adobe AIR.framework"
export COLOR='\033[0;35m'
export NC='\033[0m' # No Color
clear
echo ====================================================
printf "${COLOR}GENERATING ANE${NC}"
echo
echo ====================================================



# mv /Users/fluocode/Library/Developer/Xcode/DerivedData/AirNativeShare-etaabvsolgpjnkcjkzfkkltppzja/Build/Products/Debug-iphoneos/libAirNativeShare.a ./iPhone-ARM/libAirNativeShare.a


rm -f catalog.xml
rm -f library.swf

unzip ${NAME}.swc -d ./


cp -fr library.swf ./Android-ARM/library.swf
cp -fr library.swf ./Android-x86/library.swf
cp -fr library.swf ./Android-ARM64/library.swf
cp -fr library.swf ./iPhone-ARM/library.swf
cp -fr library.swf ./default/library.swf


export IOS_PLATFORM="-platform iPhone-ARM -C iPhone-ARM . "
export IOSx86_PLATFORM="-platform iPhone-x86 -C iPhone-x86 . "
export ANDROID_PLATFORM="-platform Android-ARM -C Android-ARM . "
export ANDROID_A64="-platform Android-ARM64 -C Android-ARM64 . " 
export ANDROID_X86="-platform Android-x86 -C Android-x86 ." 
export MAC_PLATFORM="-platform MacOS-x86 -C macos . "
export DEFAULT_PLATFORM="-platform default -C default ." 


export COMMAND="${ADT} -package -target ane ${NAME}.ane extension.xml -swc ${NAME}.swc ${IOS_PLATFORM} ${ANDROID_PLATFORM} ${ANDROID_X86} ${ANDROID_A64} ${DEFAULT_PLATFORM}"
$COMMAND


mv ./${NAME}.ane  /Users/fluocode/Documents/PixelShape/lib/${NAME}.ane







