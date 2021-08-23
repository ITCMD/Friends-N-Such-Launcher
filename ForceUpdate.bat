@echo off
title Updating Friends N Such
if "%cd%"=="%temp%" goto continue
copy /Y "%~0" "%temp%"
call "%temp%\%~nx0" "%cd%" & exit /b
exit /b
:continue
ping google.com -n 1 >nul
if not %errorlevel%==0 (
	echo [91mERROR: No internet connection.[90m
	echo Could not reach google.com.[0m
	pause
	exit
)
if exist "PingTest" del /f /q "PingTest"
curl -LJO -s https://github.com/ITCMD/Friends-N-Such-Mods/raw/main/PingTest >nul
find "[Success]" "PingTest" >nul
if not %errorlevel%==0 (
	echo [91mERROR: Download Failed for unknown reason. Contact Lucas.[90m
	echo PingTest to local Github File Failed.[0m
	pause
	exit
)
echo [92mForcing Remap . . .[0m
if exist Friends-N-Such-Mods-main.zip del /f /q Friends-N-Such-Mods-main.zip
if exist "Friends-N-Such-Mods-main\" rmdir /s /q "Friends-N-Such-Mods-main"
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO -S https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe
echo [96mDownloading latest modpack . . .[0m
curl -LJO -S https://github.com/ITCMD/Friends-N-Such-Mods/archive/refs/heads/main.zip >nul
echo [96mUnzipping . . .[0m
7za.exe x Friends-N-Such-Mods-main.zip >nul
if exist "Friends-N-Such-Mods-main\Prepare.bat" call "Friends-N-Such-Mods-main\Prepare.bat" "%~1"
echo [96mCopying Files to %~1 . . .[0m
XCOPY "Friends-N-Such-Mods-main\*" "%~1" /s /i /y
echo [96mCleaning up . . .[0m
if exist "Friends-N-Such-Mods-main\Cleanup.bat" call "Friends-N-Such-Mods-main\Cleanup.bat"
if exist Friends-N-Such-Mods-main.zip del /f /q Friends-N-Such-Mods-main.zip
if exist "Friends-N-Such-Mods-main\" rmdir /s /q "Friends-N-Such-Mods-main"
echo [92mDone![0m
:launch
timeout /t 5 /nobreak
if exist "%~1\..\..\..\MultiMC.exe" (
	echo Launching . . .[0m
	"%~1\..\..\..\MultiMC.exe" -l "Friends N Such MultiMC"
	exit /b
)
exit /b
