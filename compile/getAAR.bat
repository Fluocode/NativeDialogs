@ECHO OFF
cls
set "curpath=%~dp0"

"C:\Program Files\7-Zip\7z" e ../ANDROID/app/build/outputs\aar\app-release.aar -o%curpath% classes.jar -r

ping 1.1.1.1 -n 1 -w 8000 > nul

 
echo "DONE!" 


pause
