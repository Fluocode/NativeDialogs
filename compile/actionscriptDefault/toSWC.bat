@ECHO OFF
CLS



SET AIR="C:\Users\Emmanuel\Documents\AIRSDK\AIR33.1.1.929
SET ADT=%AIR%\bin\adt"
SET NAME=NativeDialogs


set filename=NativeDialogs
SET SWFVERSION=10
SET ACOMPC=%AIR%\bin\acompc"
SET location=%~dp0\

ECHO GENERATING SWC!!!!


::echo %ACOMPC% -source-path "%location%src" -include-sources "%location%src" -optimize -output %location\%"%filename%.swc"
::%ACOMPC% -source-path "%location%src" -include-sources "%location%src" -optimize -swf-version=%SWFVERSION%  -output %location\%"%filename%.swc"
echo %ACOMPC% -source-path "%location%src" -include-sources "%location%src"  -swf-version=%SWFVERSION%  -output %location\%"%filename%.swc"
%ACOMPC% -source-path "%location%src" -include-sources "%location%src"  -swf-version=%SWFVERSION%  -output %location\%"%filename%.swc"

pause






