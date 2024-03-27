#!/bin/bash
clear


export COLOR='\033[0;37m'
export NC='\033[0m' # No Color
clear
echo ====================================================
printf "${COLOR}TEST LIB${NC}"
echo
echo ====================================================

sh _toSWC.sh

sh _rebuildANE.sh

# sh /Users/fluocode/Documents/ANE-NativeShare-master/sample/_toSWF.sh

# sh /Users/fluocode/Documents/ANE-NativeShare-master/sample/_compile.sh









