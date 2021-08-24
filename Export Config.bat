@echo off
cls
:expcfg
cls
if not exist "options.txt" (
	echo No Configs were found.
	echo.
	echo This should be run in the .minecraft folder.
	echo If you haven't run the game, there will be no config.
	pause
	exit /b
)
echo Exporting Config . . .
echo.
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe >nul 2>nul
set conf=%random%
echo.>FNS.ID.CFG
7za.exe a "FNS-Config-%conf%.7z" "options.txt" "optionsof.txt" "optionsshaders.txt" "servers.dat" "FNS.ID.CFG" 2>nul >nul
del /f /q FNS.ID.CFG
echo saved to [92mFNS-Config-%conf%.7z[0m
pause
exit /b