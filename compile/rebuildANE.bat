@ECHO OFF

move libNativeDialogs.a iPhone-ARM/libNativeDialogs.a


move classes.jar libNativeDialogs.jar


copy libNativeDialogs.jar Android-ARM/libNativeDialogs.jar
::copy libNativeDialogs.jar Android-x86/libNativeDialogs.jar
copy libNativeDialogs.jar Android-ARM64/libNativeDialogs.jar
move libNativeDialogs.jar Android-x86/libNativeDialogs.jar



 

SET AIR="C:\Users\esdeb\Documentos\AIRSDK\AIRSDK_50.2.4.3
SET ACOMPC=%AIR%\bin\acompc"
SET ADT=%AIR%\bin\adt"

SET NAME=NativeDialogs

:: SET SWFVERSION=18

:: ECHO GENERATING LIBRARY from SWC

:: "C:\Program Files\7-Zip\7zFM.exe"
"C:\Program Files\7-Zip\7z" e %NAME%.swc -y

ping 1.1.1.1 -n 1 -w 1000 > nul

copy library.swf Android-ARM/library.swf
copy library.swf Android-x86/library.swf
copy library.swf Android-ARM64/library.swf
copy library.swf iPhone-ARM/library.swf

:: del library.swf
del catalog.xml


:: -platformoptions iPhone-ARM/platform.xml 
SET IOS_PLATFORM=-platform iPhone-ARM -C iPhone-ARM . 
SET IOSx86_PLATFORM=-platform iPhone-x86 -C iPhone-x86 . 
SET ANDROID_PLATFORM=-platform Android-ARM -C Android-ARM . 
SET ANDROID_A64=-platform Android-ARM64 -C Android-ARM64 . 
SET ANDROID_X86=-platform Android-x86 -C Android-x86 . 
SET MAC_PLATFORM=-platform MacOS-x86 -C macos . 
SET DEFAULT_PLATFORM=-platform default -C actionscriptDefault . 


echo "GENERATING ANE"
::echo %ADT% -package -target ane %NAME%.ane extension.xml -swc %NAME%.swc %IOS_PLATFORM% %IOSx86_PLATFORM% %ANDROID_PLATFORM% %ANDROID_X86% %DEFAULT_PLATFORM%
::%ADT% -package -target ane %NAME%.ane extension.xml -swc %NAME%.swc %IOS_PLATFORM% %IOSx86_PLATFORM% %ANDROID_PLATFORM% %ANDROID_X86% %DEFAULT_PLATFORM%

echo %ADT% -package -target ane %NAME%.ane extension.xml -swc %NAME%.swc %IOS_PLATFORM% %ANDROID_PLATFORM% %ANDROID_X86% %ANDROID_A64% %DEFAULT_PLATFORM%
%ADT% -package -target ane %NAME%.ane extension.xml -swc %NAME%.swc %IOS_PLATFORM% %ANDROID_PLATFORM% %ANDROID_X86% %ANDROID_A64% %DEFAULT_PLATFORM%


::echo "GENERATING ANE..."
::%ADT% -package -target ane %NAME%.ane extension.xml -swc %NAME%.swc -platform Android-ARM -C Android-ARM . -platformoptions Android-ARM/platformoptions.xml -platform default -C default .

ping 1.1.1.1 -n 1 -w 8000 > nul

 
echo "DONE!" 


:: move NativeDialogs.ane "C:/Users/Emmanuel/Documents/_PROYECTS/TestANE/lib/NativeDialogs.ane"

pause
