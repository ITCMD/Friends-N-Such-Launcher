@echo off
title Friends N Such Minecraft Launcher
setlocal EnableDelayedExpansion
set status=Up To Date
set ver=1.9
set betterfoliageurl=https://media.forgecdn.net/files/3409/419/BetterFoliage-2.7.1-Forge-1.16.5.jar
if "%~1"=="--ContinueUpdate" goto :ContinueUpdate
if /i "%~1"=="--Panel" start https://mc.itcommand.net:8056
if not exist "MultiMC\Instances\Friends N Such\Friends-N-Such.Identifier" goto setup
if not exist "MultiMC\DidSetup.ini" goto :multisetup
ping google.com -n 1 >nul
if not %errorlevel%==0 (
	echo [91mERROR: No internet connection[90m
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
if exist updateLauncher.cmd del /f /q updateLauncher.cmd
echo [96mClosing any open Javaw.exe Windows . . .[0m
taskkill /f /im javaw.exe >nul 2>nul
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
timeout /t 4 >nul
goto multisetup


:multisetup
cls
echo Loading System Info . . .
for /f "tokens=1,2 delims=:" %%A in ('systeminfo ^| find "Total Physical Memory"') do (set m=%%~B) >nul 2>nul
:donemem
echo [92mCongrats[0m
echo MultiMC and Friends N Such are installed, however MultiMC Must be set up.
echo.
echo [92mJava[0m
echo MultiMC Will launch now. It will ask you to select a java path.
echo [4mSelect a x64 Java install[0m, not one in Program Files(x86).
echo If you do not have x64 Java installed, close this and install it now.
echo.
echo [92mMemory[0m
echo By Default, MultiMC only provides Minecraft with 1GB of RAM (1024 Mb).
echo It's recommended you set the maximum RAM to around 5GB of system
echo memory. You have %m% Mb of RAM.
echo.
echo [92mAccount[0m
echo MultiMC Will ask you to add a Minecraft account.
echo This account info is [4msecurely[0m stored locally.
echo You can also add multiple accounts and switch between them freely.
echo MultiMC should ask you for an account automatically.
echo.
echo Once you have completed these steps, close MultiMC and return here.
pause
echo.>"MultiMC\DidSetup.ini"
call "MultiMC\MultiMC.exe"
cls
echo.
echo You finished the setup. You can change these settings later form the main menu.
timeout /t 5
goto mainmenu


:mainmenu
if exist 7za.exe del /f /q 7za.exe
cls
title Friends N Such Minecraft Launcher
echo ========================================================================
echo [32m            .-/ss+:.
echo [32m        .:+shyyyyyyo/-`       
echo [32m   `.:+syyyyyyyyyyyhyyso/-`       
echo [32m  oyyyhhyyyyyyyyyyyyhyyyyyys:     [92;7m Friends N Such Minecraft [0;90m
echo [90m  hhh[32myyyyyyyyyyyyyyyyyyhhh[90mmdo     [90m[===  By  SystemInfo  ===][0m
echo [90m  hhhyhh[32mdyyyyyyyyhyhhdd[90mddmddd     [0mVersion:  %ver% [[90m%status%[0m][90m
echo [90m  hhyhhdhhh[32mhhhhhhddd[90mdmdddddd+     [0mServer:   mc.itcommand.net[90m


curl ftp://mc.itcommand.net:21/players.txt --user "mcplayers:mojang" -o players.txt >nul 2>nul
if %errorlevel%==0 (
	echo [90m  yyyyhdddhhh[32mhhddd[90mddddmdhdddo     [0mStatus:   [32mHost Online[90m
	curl ftp://mc.itcommand.net:21/explore/players.txt --user "mcplayers:mojang" -o exploreplayers.txt >nul 2>nul
) ELSE (
	echo [90m  yyyyhdddhhh[32mhhddd[90mddddmdhdddo     [0mStatus:   [91mHost No Reply[90m
	echo.>players.txt
)
curl -LJ https://api.mcsrvstat.us/2/mc.itcommand.net:25565 -o stat.json 2>nul
if not "%errorlevel%"=="0" (
	echo [90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo     [0mStatus:   Unknown
	goto skipstatus
)
find ",""online"":true,""" "stat.json" >nul 2>nul
if %errorlevel%==0 (
	echo [90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo     [0mPrimary:  [32mServer Online[90m
) ELSE (
	echo [90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo     [0mPrimary:  [91mServer Offline[90m
	set offline=true
)
:skipstatus

curl -LJ https://api.mcsrvstat.us/2/mc.itcommand.net:25567 -o stat2.json 2>nul
if not "%errorlevel%"=="0" (
	echo [90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo     [0mStatus:   Unknown
	goto skip2status
)
find ",""online"":true,""" "stat2.json" >nul 2>nul
if %errorlevel%==0 (
	echo [90m  hhhyyyhyyhyhyhdhdddhdhddhh+     [0mExplore:  [32mServer Online[90m
) ELSE (
	echo [90m  hhhyyyhyyhyhyhdhdddhdhddhh+     [0mExplore:  [91mServer Offline[90m
	set expoffline=true
)
:skip2status
del /f /q stat.json
del /f /q stat2.json
set players=
set expplayers=
if exist players.txt (
	set count=0
	for /f %%A in (players.txt) do (
		if "!count!"=="0" (
			set players=%%~A
		) ELSE (
			set players=!players!, %%~A
		)
		set /a count+=1
	)
)
if exist exploreplayers.txt (
	set count=0
	for /f %%A in (exploreplayers.txt) do (
		if "!count!"=="0" (
			set expplayers=%%~A
		) ELSE (
			set expplayers=!expplayers!, %%~A
		)
		set /a count+=1
	)
)
if exist players.txt del /f /q players.txt
echo   oyyhhyhhyhyyyhhdhhhdddddhy/     [0mPrimary Players: [7m!players![0;90m
echo    `./oyyyyhhyyhddddddhs+:`       [0mExplore Players: [7m!expplayers![0;90m
echo        `.:oyyyyhddhy+:`       
echo            `-/syo:.``             Main Menu[0m
echo.[0m
echo ========================================================================
echo 1] Launch Game
echo E] Open FNS Explorer Menu [96m(New^^!)[0m
echo 2] Export Config [90m(Sensitivity, graphics, shader settings)[0m
echo 3] Import Config
echo 4] Reset Mods [90m(Force Update)[0m
echo 5] Reset Instance
echo 6] Full Reset
echo 7] Open MultiMC menu [90m(Settings, accounts)[0m
echo 8] Toggle Better Foliage [90m(Requires additional Resources)[0m
echo 9] Open Latest Log
echo [90mX] Exit ^| [R] Refresh[0m
echo.
choice /c 123456789XLER
if %errorlevel%==1 goto launch
if %errorlevel%==2 goto expcfg
if %errorlevel%==3 goto impcfg
if %errorlevel%==4 goto resmods
if %errorlevel%==5 goto resetint
if %errorlevel%==6 goto fullreset
if %errorlevel%==7 goto justmultimc
if %errorlevel%==8 goto betterf
if %errorlevel%==9 start "" "MultiMC\Instances\Friends N Such\.minecraft\logs\latest.log"
if %errorlevel%==10 goto exit
if %errorlevel%==11 start https://mc.itcommand.net:8056
if %errorlevel%==12 goto explorer
if %errorlevel%==13 goto mainmenu
goto mainmenu


:explorer
cls
if not exist "MultiMC\Instances\FNS Exploring\.minecraft" goto setexpl
if exist 7za.exe del /f /q 7za.exe
cls
title Friends N Such Minecraft Launcher
echo ========================================================================
echo [96m            .-/ss+:.
echo [96m        .:+shyyyyyyo/-`       
echo [96m   `.:+syyyyyyyyyyyhyyso/-`       
echo [96m  oyyyhhyyyyyyyyyyyyhyyyyyys:     [96;7m Friends N Such Minecraft [0;90m
echo [90m  hhh[96myyyyyyyyyyyyyyyyyyhhh[90mmdo     [90m[===  By  SystemInfo  ===][0m
echo [90m  hhhyhh[96mdyyyyyyyyhyhhdd[90mddmddd     [0mVersion:  %ver% [[90m%status%[0m][90m
echo [90m  hhyhhdhhh[96mhhhhhhddd[90mdmdddddd+     [0mServer:   mc.itcommand.net[90m


curl ftp://mc.itcommand.net:21/players.txt --user "mcplayers:mojang" -o players.txt >nul 2>nul
if %errorlevel%==0 (
	echo [90m  yyyyhdddhhh[96mhhddd[90mddddmdhdddo     [0mStatus:   [92mHost Online[90m
	curl ftp://mc.itcommand.net:21/explore/players.txt --user "mcplayers:mojang" -o exploreplayers.txt >nul 2>nul
) ELSE (
	echo [90m  yyyyhdddhhh[96mhhddd[90mddddmdhdddo     [0mStatus:   [91mHost No Reply[90m
	echo.>players.txt
)
curl -LJ https://api.mcsrvstat.us/2/mc.itcommand.net:25565 -o stat.json 2>nul
if not "%errorlevel%"=="0" (
	echo [90m  hhyyyhyhhhmh[96mhhd[90mhhddhhdhhhdo     [0mStatus:   Unknown
	goto eskipstatus
)
find ",""online"":true,""" "stat.json" >nul 2>nul
if %errorlevel%==0 (
	echo [90m  hhyyyhyhhhmh[96mhhd[90mhhddhhdhhhdo     [0mPrimary:  [92mServer Online[90m
) ELSE (
	echo [90m  hhyyyhyhhhmh[96mhhd[90mhhddhhdhhhdo     [0mPrimary:  [91mServer Offline[90m
	set offline=true
)
:eskipstatus

curl -LJ https://api.mcsrvstat.us/2/mc.itcommand.net:25567 -o stat2.json 2>nul
if not "%errorlevel%"=="0" (
	echo [90m  hhyyyhyhhhmh[96mhhd[90mhhddhhdhhhdo     [0mStatus:   Unknown
	goto eskip2status
)
find ",""online"":true,""" "stat2.json" >nul 2>nul
if %errorlevel%==0 (
	echo [90m  hhhyyyhyyhyhyhdhdddhdhddhh+     [0mExplore:  [92mServer Online[90m
) ELSE (
	echo [90m  hhhyyyhyyhyhyhdhdddhdhddhh+     [0mExplore:  [91mServer Offline[90m
	set expoffline=true
)
:eskip2status
del /f /q stat.json
del /f /q stat2.json
if exist players.txt (
	set count=0
	for /f %%A in (players.txt) do (
		if "!count!"=="0" (
			set players=%%~A
		) ELSE (
			set players=!players!, %%~A
		)
		set /a count+=1
	)
)
if exist exploreplayers.txt (
	set count=0
	for /f %%A in (exploreplayers.txt) do (
		if "!count!"=="0" (
			set expplayers=%%~A
		) ELSE (
			set expplayers=!expplayers!, %%~A
		)
		set /a count+=1
	)
)
if exist players.txt del /f /q players.txt
if exist exploreplayers.txt del /f /q exploreplayers.txt
echo   oyyhhyhhyhyyyhhdhhhdddddhy/     [0mPrimary Players:  [7m!players![0;90m
echo    `./oyyyyhhyyhddddddhs+:`       [0mExplore Players:  [7m!expplayers![0;90m
echo        `.:oyyyyhddhy+:`     
echo            `-/syo:.``             Explorer Menu[0m  Port: 25567
echo.
echo.
echo ===============================================
echo [0m1] Launch Exploring Instance
echo 2] Import Config
echo 3] Refresh Explorer Mods [90m(Force Update)[0m
echo 4] Toggle Better Foliage
echo 5] Open Latest Log
echo [90mX] Main Menu  ^|  [R] Refresh[0m
choice /c 12345xr
if %errorlevel%==1 goto launchexp
if %errorlevel%==2 goto importexp
if %errorlevel%==5 notepad "MultiMC\Instances\FNS Exploring\.minecraft\logs\latest.log"
if %errorlevel%==3 (
	cls
	taskkill /f /im javaw.exe >nul 2>nul
	rmdir /s /q "MultiMC\Instances\FNS Explorer\mods"
	mkdir "MultiMC\Instances\FNS Explorer\mods\"
	cd "MultiMC\Instances\FNS Explorer\mods\"
	goto setupexpmods
)
if %errorlevel%==4 goto 2betterfexp
if %errorlevel%==6 goto mainmenu
if %errorlevel%==7 goto explorer

goto explorer

 

:launchexp
cls
echo [92mLaunching FNS Explorer . . .[90m
echo MultiMC Version:
call "MultiMC\MultiMC.exe" -V 
timeout /t 2 >nul 2>nul
echo [92mStarting Instance . . .[0m
echo @echo off>MultiMC\QuickLaunchEXP.cmd"
echo title MultiMC FNS Exploring Launcher>>MultiMC\QuickLaunchEXP.cmd"
echo call "MultiMC\MultiMC.exe" -l "FNS Exploring">>MultiMC\QuickLaunchEXP.cmd"
start /MIN "" "MultiMC\QuickLaunchEXP.cmd"
timeout /t 5
goto explorer

:importexp
cls
md Confg
cd Confg
echo Drag and drop Config 7z file to here:
set /p cfg=">"
set cfg=%cfg:"=%
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe 2>nul >nul
7za l "%cfg%" | find "FNS.ID.CFG" >nul
if %errorlevel%==1 (
	echo Invalid Friends-N-Such-Config.
	cd ..
	rmdir Confg
	pause
	goto mainmenu
)
7za.exe e "%cfg%" >nul
move /Y "*.txt" "..\MultiMC\Instances\FNS Exploring\.minecraft\" >nul
echo [92mImport Complete.[0m
cd ..
rmdir /s /q Confg
pause
goto explorer

:setexpl
cls
cd MultiMC\Instances
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe 2>nul >nul
echo [96mDownloading Instance . . .[0m
curl -LJO https://github.com/ITCMD/Friends-N-Such-Launcher/raw/main/ExplorerInstance.zip >nul 2>nul
echo [96m Unzipping . . .[0m
7za x ExplorerInstance.zip >nul
del /f /q ExplorerInstance.zip
move "7za.exe" "FNS Exploring\.minecraft\mods\" >nul
cd "FNS Exploring\.minecraft\mods\"

:setupexpmods
if not exist "7za.exe" curl -LJO https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe 2>nul >nul
echo [96mDownloading Mods . . .[0m
echo [90mThis may take several minutes . . .[0m
curl ftp://mc.itcommand.net:21/explore/ExplorerMods.zip --user "mcplayers:mojang" -o ExplorerMods.zip
7za x ExplorerMods.zip >nul
del /f /q 7za.exe
del /f /q ExplorerMods.zip
cd ..\..\..\..\..
goto explorer



:2betterfexp
cls
if exist "MultiMC\Instances\FNS Explorer\.minecraft\mods\BetterFoliage*" (
	echo Mod is currently enabled.
	echo Disable?
	choice
	if !errorlevel!==1 del /f /q "MultiMC\Instances\FNS Explorer\.minecraft\mods\BetterFoliage*"
	goto explorer
)
echo Mod is currently Disabled.
echo Enable?
choice
if %errorlevel%==2 goto explorer
curl -LJO %betterfoliageurl% >nul 2>nul
move "BetterFoliage*" "MultiMC\Instances\FNS Explorer\.minecraft\mods\" >nul
echo [92mMod Enabled[0m
pause
goto explorer

:betterf
cls
if exist "MultiMC\Instances\Friends N Such\.minecraft\mods\BetterFoliage*" (
	echo Mod is currently enabled.
	echo Disable?
	choice
	if !errorlevel!==1 del /f /q "MultiMC\Instances\Friends N Such\.minecraft\mods\BetterFoliage*"
	goto mainmenu
)
echo Mod is currently Disabled.
echo Enable?
choice
if %errorlevel%==2 goto mainmenu
curl -LJO %betterfoliageurl% >nul 2>nul
move "BetterFoliage*" "MultiMC\Instances\Friends N Such\.minecraft\mods\" >nul
echo [92mMod Enabled[0m
pause
goto mainmenu


:justmultimc
cls
echo Launching MultiMC by itself.
start /MIN "" "MultiMC\MultiMC.exe"
timeout /t 5
goto mainmenu



:resetint
echo Are you sure?
choice
if %errorlevel%==2 goto mainmenu
cls
echo [96mResetting Instance . . .
taskkill /f /im javaw.exe >nul 2>nul
rmdir /s /q "MultiMC\Instances\Friends N Such"
goto newinstance


:expcfg
cls
if not exist "MultiMC\Instances\Friends N Such\.minecraft\options.txt" (
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
md Confg
cd Confg
echo Drag and drop Config 7z file to here:
set /p cfg=">"
set cfg=%cfg:"=%
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe 2>nul >nul
7za l "%cfg%" | find "FNS.ID.CFG" >nul
if %errorlevel%==1 (
	echo Invalid Friends-N-Such-Config.
	cd ..
	rmdir Confg
	pause
	goto mainmenu
)
7za.exe e "%cfg%" >nul
move /Y "*.txt" "..\MultiMC\Instances\Friends N Such\.minecraft\" >nul
echo [92m Import Complete.[0m
cd ..
rmdir /s /q Confg
pause
goto mainmenu




:launch
cls
if "%offline%"=="true" (
	echo Server appears offline. Continue?
	choice
	if !errorlevel!==2 goto mainmenu
)
echo [92mLaunching Friends N Such . . .[90m
echo MultiMC Version:
call "MultiMC\MultiMC.exe" -V 
timeout /t 2 >nul 2>nul
echo [92mStarting Instance . . .[0m
echo @echo off>MultiMC\QuickLaunchFNS.cmd"
echo title MultiMC FNS Launcher>>MultiMC\QuickLaunchFNS.cmd"
echo call "MultiMC\MultiMC.exe" -l "Friends N Such">>MultiMC\QuickLaunchFNS.cmd"
start /MIN "" "MultiMC\QuickLaunchFNS.cmd"
timeout /t 5
goto mainmenu



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









	