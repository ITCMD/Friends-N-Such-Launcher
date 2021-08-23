@echo off
title Friends N Such Minecraft Launcher
setlocal EnableDelayedExpansion
set status=Up To Date
set ver=1.5
if "%~1"=="--ContinueUpdate" goto :ContinueUpdate
if not exist "MultiMC\Instances\Friends N Such\Friends-N-Such.Identifier" goto setup
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
timeout /t 3 >nul
echo [96mUpdating Launcher . . .[0m
curl https://raw.githubusercontent.com/ITCMD/Friends-N-Such-Launcher/main/Launcher.bat -o LauncherUpdate.dat >nul 2>nul
echo ^@echo off >UpdateLauncher.cmd
echo find "title Friends N Such Minecraft Launcher" "LauncherUpdate.dat" ^>nul 2^>nul >>UpdateLauncher.cmd
echo if not %%errorlevel%%==0 echo Launcher Update Failed ^& pause ^& exit >>UpdateLauncher.cmd
echo del /f /q "%~nx0" >>UpdateLauncher.cmd
echo ren "LauncherUpdate.dat" "%~nx0" >>UpdateLauncher.cmd
echo "%~nx0" "--ContinueUpdate" >>UpdateLauncher.cmd
updateLauncher.cmd
:ContinueUpdate
echo [96mUpdating Friends N Such . . .[0m
echo [96mForcing Remap . . .[0m
if exist Friends-N-Such-Mods-main.zip del /f /q Friends-N-Such-Mods-main.zip
if exist "Friends-N-Such-Mods-main\" rmdir /s /q "Friends-N-Such-Mods-main"
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO -S https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe >nul 2>nul
echo [96mDownloading latest modpack . . .[0m
curl -LJO -S https://github.com/ITCMD/Friends-N-Such-Mods/archive/refs/heads/main.zip >nul 2>nul
echo [96mUnzipping . . .[0m
7za.exe x Friends-N-Such-Mods-main.zip >nul
if exist "Friends-N-Such-Mods-main\Prepare.bat" call "Friends-N-Such-Mods-main\Prepare.bat" "MultiMC\Instances\Friends N Such\.minecraft\"
echo [96mCopying Files . . .[0m
XCOPY "Friends-N-Such-Mods-main\*" "MultiMC\Instances\Friends N Such\.minecraft\" /s /i /y >nul
echo [96mCleaning up . . .[0m
if exist "Friends-N-Such-Mods-main\Cleanup.bat" call "Friends-N-Such-Mods-main\Cleanup.bat" "MultiMC\Instances\Friends N Such\.minecrat\"
if exist Friends-N-Such-Mods-main.zip del /f /q Friends-N-Such-Mods-main.zip
if exist "Friends-N-Such-Mods-main\" rmdir /s /q "Friends-N-Such-Mods-main"
echo [92mDone![0m
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
	if exist "PingTest" del /f /q "PingTest"
	pause
	exit
)
if exist "PingTest" del /f /q "PingTest"
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
call ..\..\7za.exe x ..\..\LatestInstall.zip >nul 2>nul
cd ..\..
echo [96mDownloading Mods and other Files . . .[0m
if exist Friends-N-Such-Mods-main.zip del /f /q Friends-N-Such-Mods-main.zip
if exist "Friends-N-Such-Mods-main\" rmdir /s /q "Friends-N-Such-Mods-main"
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO -S https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe >nul 2>nul
echo [96mDownloading latest modpack . . .[0m
curl -LJO -S https://github.com/ITCMD/Friends-N-Such-Mods/archive/refs/heads/main.zip >nul 2>nul
echo [96mUnzipping . . .[0m
7za.exe x Friends-N-Such-Mods-main.zip >nul 2>nul
if exist "Friends-N-Such-Mods-main\Prepare.bat" call "Friends-N-Such-Mods-main\Prepare.bat" "MultiMC\Instances\Friends N Such\.minecraft\"
echo [96mCopying Files . . .[0m
XCOPY "Friends-N-Such-Mods-main\*" "MultiMC\Instances\Friends N Such\.minecraft\" /s /i /y >nul 2>nul
echo [96mCleaning up . . .[0m
if exist "Friends-N-Such-Mods-main\Cleanup.bat" call "Friends-N-Such-Mods-main\Cleanup.bat" "MultiMC\Instances\Friends N Such\.minecrat\"
if exist Friends-N-Such-Mods-main.zip del /f /q Friends-N-Such-Mods-main.zip
if exist "Friends-N-Such-Mods-main\" rmdir /s /q "Friends-N-Such-Mods-main"
echo [92mCleaning up . . .[0m
del /f /q LatestInstall.zip
del /f /q mmc-stable-win32.zip
echo [92mDone![0m
timeout /t 2 >nul
goto mainmenu


:mainmenu
del /f /q 7za.exe
cls
title Friends N Such Minecraft Launcher
echo ========================================================================
echo [32m            .-/ss+:.
echo [32m        .:+shyyyyyyo/-`       
echo [32m   `.:+syyyyyyyyyyyhyyso/-`       
echo [32m  oyyyhhyyyyyyyyyyyyhyyyyyys: 
echo [90m  hhh[32myyyyyyyyyyyyyyyyyyhhh[90mmdo     [92;7m Friends N Such Minecraft [0;90m
echo [90m  hhhyhh[32mdyyyyyyyyhyhhdd[90mddmddd     [0mVersion:  %ver% [[90m%status%[0m][90m
echo [90m  hhyhhdhhh[32mhhhhhhddd[90mdmdddddd+     [0mServer:   mc.itcommand.net[90m
curl -s http://play.itcommand.net:9444/hooks/Internal-Ping 2>nul | find "Pong OK." >nul 2>nul
if %errorlevel%==0 (
	echo [90m  yyyyhdddhhh[32mhhddd[90mddddmdhdddo     [0mStatus:   [32mHost Online[90m
) ELSE (
	echo [90m  yyyyhdddhhh[32mhhddd[90mddddmdhdddo     [0mStatus:   [32mHost Online[90m
)
curl -LJ https://api.mcsrvstat.us/2/play.itcommand.net -o stat.json 2>nul
if not "%errorlevel%"=="0" (
	echo [90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo     [0mStatus:   Unknown
	goto skipstatus
)
find ",""online"":true,""" "stat.json" >nul 2>nul
if %errorlevel%==0 (
	echo [90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo     [0mStatus:   [32mServer Online[90m
) ELSE (
	echo [90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo     [0mStatus:   [91mServer Offline[90m
)
:skipstatus
curl http://webhook.itcommand.net:9444/hooks/players -o players.txt >nul 2>nul
if %errorlevel%==0 (
	for /f %%A in (players.txt) do (set players=!players!, %%~A)
)
echo   hhhyyyhyyhyhyhdhdddhdhddhh+     [0mPlayers:  [7m!players![0;90m

echo   oyyhhyhhyhyyyhhdhhhdddddhy/ 
echo    `./oyyyyhhyyhddddddhs+:`   
echo        `.:oyyyyhddhy+:`       
echo            `-/syo:.``[0m

echo.[0m
echo ========================================================================
echo 1] Launch Game
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
if %errorlevel%==6 goto exit



:expcfg
cls
pause not exist "MultiMC\Instances\Friends N Such\.minecraft\options.txt" (
	echo No Options were found. You'll have to run the game first.
	pause
	goto mainmenu
)
echo Exporting Config . . .
echo.
cd MultiMC\Instances\Friends N Such\.minecraft
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe >nul 2>nul
set conf=%random%
echo.>FNS.ID.CFG
7za.exe a "FNS-Config-%conf%.7z" "options.txt" "optionsof.txt" "optionsshaders.txt" "servers.dat" "FNS.ID.CFG" 2>nul >nul
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
cls
echo [92mResetting mods . . .[0m
del /f /q "MultiMC\Instances\Friends N Such\.minecraft\mods\*.*"
echo [96mForcing Remap . . .[0m
if exist Friends-N-Such-Mods-main.zip del /f /q Friends-N-Such-Mods-main.zip
if exist "Friends-N-Such-Mods-main\" rmdir /s /q "Friends-N-Such-Mods-main"
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO -S https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe >nul 2>nul
echo [96mDownloading latest modpack . . .[0m
curl -LJO -S https://github.com/ITCMD/Friends-N-Such-Mods/archive/refs/heads/main.zip >nul 2>nul
echo [96mUnzipping . . .[0m
7za.exe x Friends-N-Such-Mods-main.zip >nul
if exist "Friends-N-Such-Mods-main\Prepare.bat" call "Friends-N-Such-Mods-main\Prepare.bat" "MultiMC\Instances\Friends N Such\.minecraft\"
echo [96mCopying Files . . .[0m
XCOPY "Friends-N-Such-Mods-main\*" "MultiMC\Instances\Friends N Such\.minecraft\" /s /i /y
echo [96mCleaning up . . .[0m
if exist "Friends-N-Such-Mods-main\Cleanup.bat" call "Friends-N-Such-Mods-main\Cleanup.bat" "MultiMC\Instances\Friends N Such\.minecrat\"
if exist Friends-N-Such-Mods-main.zip del /f /q Friends-N-Such-Mods-main.zip
if exist "Friends-N-Such-Mods-main\" rmdir /s /q "Friends-N-Such-Mods-main"
echo [92mDone![0m
timeout /t 3 >nul
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









	