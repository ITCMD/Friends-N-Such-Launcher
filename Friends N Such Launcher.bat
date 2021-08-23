@echo off
setlocal EnableDelayedExpansion
if not exist "MultiMC\Instances\Friends N Such\Friends-N-Such.Identifier" goto setup
set status=Up To Date
set ver=1.5
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
	echo [91mERROR: Connection Failed for unknown reason. Contact Lucas.[90m
	echo PingTest to local Github File Failed.[0m
	del /f /q PingTest 2>nul
	set status=Unknown
	pause
	goto mainmenu
)
del /f /q "PingTest" 2>nul
if exist ver.txt del /f /q "ver.txt"
curl -LJO -s https://github.com/ITCMD/Friends-N-Such-Mods/raw/main/ver.txt >nul
find "[%ver%]" "ver.txt" >nul
set uptodate=%errorlevel%
if "%uptodate%"=="0" (
	echo Friends-N-Such is up to date.
	del /f /q ver.txt
	goto mainmenu
)
echo Update Available. Downloading . . .
del /f /q ver.txt
cd MultiMC\Instances\Friends N Such\.minecraft
if exist ForceUpdate.bat del /f /q ForceUpdate.bat
curl -LJO -s https://github.com/ITCMD/Friends-N-Such-Launcher/raw/main/ForceUpdate.bat >nul
call "ForceUpdate.bat"
cd ..\..\..\..
timeout /t 3 >nul
goto mainmenu







:setup
cls
echo [92mPerforming First Time Setup[0m
echo.
:newinstance
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
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe 2>nul
if exist "MultiMC\MultiMC.exe" goto SkipMMC
echo [96mDownloading MultiMC . . .[0m
curl -LJO -s https://files.multimc.org/downloads/mmc-stable-win32.zip >nul
echo [96mExtracting . . .[0m
call 7za.exe x mmc-stable-win32.zip >nul
md MultiMC\Instances\
:SkipMMC
if exist "MultiMC\Instances\Friends N Such" (
	echo this will delete your current copy of Friends N Such.
	echo Continue?
	choice
	if !errorlevel!==2 exit
	rmdir /s /q "MultiMC\Instances\Friends N Such"
)
echo [96mDownloading and Creating Instance . . .[0m
curl -LJO -s https://github.com/ITCMD/Friends-N-Such-Launcher/raw/main/LatestInstall.zip >nul
cd MultiMC\Instances
call ..\..\7za.exe x ..\..\LatestInstall.zip
echo [96mDownloading Mods and other Files . . .[0m
cd "Friends N Such\.minecraft"
if exist ForceUpdate.bat del /f /q ForceUpdate.bat
curl -LJO -s https://github.com/ITCMD/Friends-N-Such-Launcher/raw/main/ForceUpdate.bat >nul
call ForceUpdate.bat
echo.
echo [92mCleaning up . . .[0m
cd ..\..\..\..
del /f /q LatestInstall.zip
del /f /q mmc-stable-win32.zip
goto mainmenu


:mainmenu
cls
title Friends N Such Minecraft Launcher
echo [92mFriends N Such Minecraft[0m
echo.
echo Version: %ver% [[90m%status%[0m].
echo Server: Play.itcommand.net
curl -S http://play.itcommand.net:9444/hooks/Internal-Ping | find "Pong OK." >nul 2>nul
if %errorlevel%==0 (
	echo Status: [32mHost Online[0m
) ELSE (
	echo Status: [91mHost Offline[0m
)
curl -LJ https://api.mcsrvstat.us/2/play.itcommand.net -o stat.json 2>nul
if not "%errorlevel%"=="0" (
	echo Status: Server Checking API is down. Unknown.
	goto skipstatus
)
find ",""online"":true,""" "stat.json" >nul 2>nul
if %errorlevel%==0 (
	echo Status: [32mServer Online[0m
) ELSE (
	echo Status: [91mServer Offline[0m
)
:skipstatus
echo.
echo Players:[7m
curl http://webhook.itcommand.net:9444/hooks/players
echo.[0m
echo.
echo [92m1] Launch Game[0m
echo 2] Export Config [90m(Sensitivity, graphics, shader settings)[0m
echo 3] Import Config
echo 4] Reset Mods [90m(Force Update)[0m
echo 5] Full Reset
echo [90mX] Exit[0m
echo.
choice /c 12345X
if %errorlevel%==1 goto launch
if %errorlevel%==2 goto expcfg
if %errorlevel%==3 goto impcfg
if %errorlevel%==4 goto resmods
if %errorlevel%==5 goto fullreset



:expcfg
cls
echo Exporting Config . . .
echo.
echo.
cd MultiMC\Instances\Friends N Such\.minecraft
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe
set conf=%random%
echo.>FNS.ID.CFG
7za.exe a "FNS-Config-%conf%.7z" "options.txt" "optionsof.txt" "optionsshaders.txt" "servers.dat" "FNS.ID.CFG"
del /f /q FNS.ID.CFG
move "FNS-Config-%conf%.7z" "..\..\..\..\"
echo saved to [92mFNS-Config-%conf%.7z[0m
pause
cd ..\..\..\..
goto mainmenu



:impcfg
cls
echo Drag and drop Config 7z file to here:
set /p cfg=">"
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe
7za l "%cfg%" | find "FNS.ID.CFG" >nul 2>nul
if %errorlevel%==1 (
	echo Invalid Friends-N-Such-Config.
	pause
	goto mainmenu
)
cd MultiMC\Instances\Friends N Such\.minecraft
7za.exe -y x "%cfg%"
echo [92m Import Complete.[0m
cd ..\..\..\..
pause
goto mainmenu




:launch
echo [92mLaunching Friends N Such . . .[0m
call "MultiMC\MultiMC.exe" -V 
"MultiMC\MultiMC.exe" -L "Friends N Such"
timeout /t 5
exit



:resmods
echo.
echo [96mResetting mods . . .[0m
echo.
cd MultiMC\Instances\Friends N Such\.minecraft
del /f /q "mods\*.*"
if exist ForceUpdate.bat del /f /q ForceUpdate.bat
curl -LJO -s https://github.com/ITCMD/Friends-N-Such-Launcher/raw/main/ForceUpdate.bat >nul
call "ForceUpdate.bat"
timeout /t 3 >nul
cd ..\..\..\..
goto mainmenu

:fullreset
cls
echo Are you sure you want to reset?
echo.
echo [90mThis will remove and reinstall MultiMC and your Friends N Such Instance.
echo Any settings will be lost (you can export non-mod settings from the main menu).
echo You will 4mnot[0;90m loose anything on the Minecraft server.[0m
echo.
echo Reset? (Y/N)
choice /c YN /n
if %errorlevel%==2 goto mainmenu
echo.
echo [96mRemoving Files . . .[0m
taskkill /f /im javaw.exe
taskkill /f /im MultiMC.exe
rmdir /S /Q "MultiMC"
echo [96mBeginning Reinstall . . .[0m
timeout /t 2 >nul
goto setup









	