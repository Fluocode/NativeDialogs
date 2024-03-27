#!/bin/bash
clear
export AIR_NOANDROIDFLAIR=true


################################
export AIRPATH="/Users/fluocode/Documents/AIRSDK"
export NAME='NativeDialogs'
export SWFVERSION=10
################################

export ACOMPC="/bin/acompc"
export ACOMPC=$AIRPATH$ACOMPC  
#xattr -d com.apple.quarantine "$AIRPATH/runtimes/air/mac/Adobe AIR.framework"
export COLOR='\033[0;33m'
export NC='\033[0m' # No Color
clear
echo ====================================================
printf "${COLOR}COMPILING SWC (ANE PROCESS)${NC}"
echo
echo ====================================================


export COMMAND="${ACOMPC} -source-path ./actionscript/src  -include-sources ./actionscript/src  -swf-version=${SWFVERSION}  -output ./${NAME}.swc"
$COMMAND








