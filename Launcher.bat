@echo off
:restartall
if "%~1"=="Load" goto load
title Friends N Such Minecraft Launcher
setlocal EnableDelayedExpansion
set status=Up To Date
set ver=4.0
set fullreset=1
set betterfoliageurl=https://media.forgecdn.net/files/3409/419/BetterFoliage-2.7.1-Forge-1.16.5.jar
if "%~1"=="--ContinueUpdate" goto :ContinueUpdate
if /i "%~1"=="--Panel" start https://mc.itcommand.net:8443
if not exist "MultiMC\Instances\Friends N Such\Friends-N-Such.Identifier" goto setup
if not exist "MultiMC\DidSetup.ini" goto :multisetup
call :startupscreen
ping google.com -n 1 >nul
if not %errorlevel%==0 (
	echo [91mERROR: No internet connection[90m
	echo Could not reach google.com.[0m
	pause
	exit
)
if exist Load.bat (
	attrib +h load.bat
) Else (
	curl https://raw.githubusercontent.com/ITCMD/Friends-N-Such-Launcher/main/Load.bat -O >nul 2>nul
	attrib +h Load.bat
)
if exist LoadingStar.exe (
	attrib +h loadingstar.exe
) Else (
	curl https://raw.githubusercontent.com/ITCMD/Friends-N-Such-Launcher/main/LoadingStar.exe -O >nul 2>nul
	attrib +h LoadingStar.exe
)
if exist "PingTest" del /f /q "PingTest"
curl -LJO -s https://raw.githubusercontent.com/ITCMD/Friends-N-Such-Launcher/main/PingTest >nul
find "[Success]" "PingTest" >nul
if not %errorlevel%==0 (
	echo [91mERROR: Connection Failed for unknown reason. Contact Lucas.[90m
	echo PingTest to local Github File Failed.[0m
	del /f /q PingTest 2>nul
	set status=Unknown
	pause
	goto mainmenu
)
if exist PingTest del /f /q "PingTest" 2>nul
curl ftp://mc.itcommand.net:21/PingTest --user "mcupdate:MCUpdate@32" -o "PingTest" --silent
find "[Success]" "PingTest" >nul
if not %errorlevel%==0 (
	echo [91mERROR: Update FTP Server Offline. Please Contact Lucas.[90m
	echo [91mERROR: FNS may be out of date.[90m
	echo PingTest to local FTP File Failed.[0m
	del /f /q PingTest 2>nul
	set status=Unknown
	pause
	goto mainmenu
)
if exist PingTest del /f /q "PingTest" 2>nul
if exist ver.txt del /f /q "ver.txt"
curl -LJO -s https://raw.githubusercontent.com/ITCMD/Friends-N-Such-Launcher/main/ver.txt >nul
find "[%ver%]" "ver.txt" >nul
set uptodate=%errorlevel%
if "%uptodate%"=="0" (
	del /f /q ver.txt
	goto checkedforlauncherupdates
)
echo Launcher update Available. Downloading . . .
del /f /q ver.txt
timeout /t 3 >nul
echo [96mUpdating Launcher . . .[0m
rem downloads updated version
curl https://raw.githubusercontent.com/ITCMD/Friends-N-Such-Launcher/main/Launcher.bat -o LauncherUpdate.dat >nul 2>nul
rem creates temporary program to replace old launcher and run it.
echo ^@echo off >UpdateLauncher.cmd
echo find "title Friends N Such Minecraft Launcher" "LauncherUpdate.dat" ^>nul 2^>nul >>UpdateLauncher.cmd
echo if not %%errorlevel%%==0 echo Launcher Update Failed ^& pause ^& exit >>UpdateLauncher.cmd
echo del /f /q "%~nx0" >>UpdateLauncher.cmd
echo ren "LauncherUpdate.dat" "%~nx0" >>UpdateLauncher.cmd
echo "%~nx0" "--ContinueUpdate" >>UpdateLauncher.cmd
updateLauncher.cmd
:ContinueUpdate
if exist updateLauncher.cmd del /f /q updateLauncher.cmd
rem it comes here after it updates the launcher file.
:checkedforlauncherupdates
if not exist "MultiMC\Instances\Friends N Such\Update.%fullreset%.latest" goto mustreset
echo [90mGetting Latest mmc-pack.json file...
if exist "MultiMC\Instances\Friends N Such\" curl ftp://mc.itcommand.net:21/Primary-mmc-pack.json --user "mcupdate:MCUpdate@32" -o "MultiMC\Instances\Friends N Such\mmc-pack.json" >nul 2>nul
echo Downloading Client Mod List...
set update=false
rem downloads server's copy of client list
call :ftpls mc.itcommand.net mcupdate MCUpdate@32 /ExplorerClient
rem checks if client has files missing in server's copy. Deletes them.
for /f "tokens=*" %%A in ('dir /b "MultiMC\Instances\FNS Exploring\.minecraft\mods\"') do (
	find "%%~A" "%output%" >nul
	if not !errorlevel!==0 (
		echo %%~A|find /i "foliage">nul
		if not !errorlevel!==0 (
			echo Deleting Outdated Mod: %%~A
			del /f /q "MultiMC\Instances\FNS Exploring\.minecraft\mods\%%~A"
			set update=true
		)
	)
)
rem checks if client is missing files in server's copy. Downloads them.		
for /f "tokens=* usebackq" %%A in ("%output%") do (
	if not exist "MultiMC\Instances\FNS Exploring\.minecraft\mods\%%~A" (
		echo Downloading New File: %%~A...
		curl ftp://mc.itcommand.net:21/ExplorerClient/%%~A --user "mcupdate:MCUpdate@32" -o "MultiMC\Instances\FNS Exploring\.minecraft\mods\%%~A" --progress-bar
		set update=true
	)
)
rem downloads server's copy of client list
call :ftpls mc.itcommand.net mcupdate MCUpdate@32 /PrimaryClient
rem checks if client has files missing in server's copy. Deletes them.
for /f "tokens=*" %%A in ('dir /b "MultiMC\Instances\Friends N Such\.minecraft\mods"') do (
	find "%%~A" "%output%" >nul
	if not !errorlevel!==0 (
		echo %%~A|find /i "foliage">nul
		if not !errorlevel!==0 (
			echo Deleting Outdated Mod: %%~A
			del /f /q "MultiMC\Instances\Friends N Such\.minecraft\mods\%%~A"
			set update=true
		)
	)
)
rem checks if client is missing files in server's copy. Downloads them.		
for /f "tokens=* usebackq" %%A in ("%output%") do (
	if not exist "MultiMC\Instances\Friends N Such\.minecraft\mods\%%~A" (
		echo Downloading New File: %%~A...
		curl ftp://mc.itcommand.net:21/PrimaryClient/%%~A --user "mcupdate:MCUpdate@32" -o "MultiMC\Instances\Friends N Such\.minecraft\mods\%%~A" --progress-bar
		set update=true
	)
)
if "%update%"=="true" (
	echo [96mUpdate complete.[0m
	timeout /t 3 /nobreak >nul
) ELSE (
	echo [96mNo updates available.[0m
	timeout /t 1 /nobreak >nul
)
goto mainmenu

:startupscreen
cls
echo [0m========================================================================
echo [32m            .-/ss+:.
echo [32m        .:+shyyyyyyo/-`       
echo [32m   `.:+syyyyyyyyyyyhyyso/-`       
echo [32m  oyyyhhyyyyyyyyyyyyhyyyyyys:     [92;7m Friends N Such Minecraft [0;90m
echo [90m  hhh[32myyyyyyyyyyyyyyyyyyhhh[90mmdo     
echo [90m  hhhyhh[32mdyyyyyyyyhyhhdd[90mddmddd 
echo [90m  hhyhhdhhh[32mhhhhhhddd[90mdmdddddd+ 
echo [90m  yyyyhdddhhh[32mhhddd[90mddddmdhdddo
echo [90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo       [32mChecking for Updates...
echo [90m  hhhyyyhyyhyhyhdhdddhdhddhh+
echo   oyyhhyhhyhyyyhhdhhhdddddhy/  
echo    `./oyyyyhhyyhddddddhs+:`      
echo        `.:oyyyyhddhy+:`       
echo            `-/syo:.`` 
echo [0m========================================================================
exit /b

:loading
cls
echo [0m========================================================================
echo [32m            .-/ss+:.
echo [32m        .:+shyyyyyyo/-`       
echo [32m   `.:+syyyyyyyyyyyhyyso/-`       
echo [32m  oyyyhhyyyyyyyyyyyyhyyyyyys:     [92;7m Friends N Such Minecraft [0;90m
echo [90m  hhh[32myyyyyyyyyyyyyyyyyyhhh[90mmdo     
echo [90m  hhhyhh[32mdyyyyyyyyhyhhdd[90mddmddd 
echo [90m  hhyhhdhhh[32mhhhhhhddd[90mdmdddddd+ 
echo [90m  yyyyhdddhhh[32mhhddd[90mddddmdhdddo
echo [90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo         [32mQuerying Servers...
echo [90m  hhhyyyhyyhyhyhdhdddhdhddhh+
echo   oyyhhyhhyhyyyhhdhhhdddddhy/  
echo    `./oyyyyhhyyhddddddhs+:`      
echo        `.:oyyyyhddhy+:`       
echo            `-/syo:.`` 
echo [0m========================================================================
echo.
echo|set /p=.                            Loading . . .  
exit /b

:setup
cls
echo [92mPerforming First Time Setup[0m
echo.
ping google.com -n 1 >nul
if not %errorlevel%==0 (
	echo [91mERROR: No internet connection.[90m
	echo Could not reach google.com.[0m
	pause
	exit
)
curl -LJO -s https://raw.githubusercontent.com/ITCMD/Friends-N-Such-Launcher/main/ver.txt >nul
find "[%ver%]" "ver.txt" >nul
set uptodate=%errorlevel%
if "%uptodate%"=="0" (
	del /f /q ver.txt
	goto ContinueSetup
)
echo Launcher update Available. Downloading . . .
del /f /q ver.txt
timeout /t 3 >nul
echo [96mUpdating Launcher . . .[0m
rem downloads updated version
curl https://raw.githubusercontent.com/ITCMD/Friends-N-Such-Launcher/main/Launcher.bat -o LauncherUpdate.dat >nul 2>nul
rem creates temporary program to replace old launcher and run it.
echo ^@echo off >UpdateLauncher.cmd
echo find "title Friends N Such Minecraft Launcher" "LauncherUpdate.dat" ^>nul 2^>nul >>UpdateLauncher.cmd
echo if not %%errorlevel%%==0 echo Launcher Update Failed ^& pause ^& exit >>UpdateLauncher.cmd
echo del /f /q "%~nx0" >>UpdateLauncher.cmd
echo ren "LauncherUpdate.dat" "%~nx0" >>UpdateLauncher.cmd
echo "%~nx0" "--ContinueSetup" >>UpdateLauncher.cmd
updateLauncher.cmd
:ContinueSetup
if exist updateLauncher.cmd del /f /q updateLauncher.cmd
:java
if exist "C:\Program Files\Java" goto skipjava
echo You do not appear to have the x64 Java Runtime Environment installed.
echo It is required to run Minecraft. Would you like to Install it now?
choice
if %errorlevel%==2 goto skipjava
echo Downloading Java 8 . . .
curl -L https://javadl.oracle.com/webapps/download/AutoDL?BundleId=245807_df5ad55fdd604472a86a45a217032c7d -o "java.exe" --progress-bar
echo Installing Java 8 . . .
call java.exe /s SPONSORS=0
echo Install Complete.
timeout /t 1 /nobreak >nul
:skipjava
if exist "PingTest" del /f /q "PingTest"
curl -LJO -s https://raw.githubusercontent.com/ITCMD/Friends-N-Such-Launcher/main/PingTest >nul
find "[Success]" "PingTest" >nul
if not %errorlevel%==0 (
	echo [91mERROR: Download Failed for unknown reason. Contact Lucas.[90m
	echo PingTest to local Github File Failed.[0m
	if exist "PingTest" del /f /q "PingTest"
	pause
	exit
)
if exist "PingTest" del /f /q "PingTest"
curl ftp://mc.itcommand.net:21/PingTest --user "mcupdate:MCUpdate@32" -o "PingTest" --silent
find "[Success]" "PingTest" >nul
if not %errorlevel%==0 (
	echo [91mERROR: Update FTP Server Offline. Please Contact Lucas.[90m
	echo PingTest to local FTP File Failed.[0m
	del /f /q PingTest 2>nul
	set status=Unknown
	pause
	exit
)
if exist PingTest del /f /q "PingTest"
echo [96mConfiguring Unzip Tool . . .[0m
if not exist "7za.exe" curl -LJO https://github.com/ITCMD/ITCMD-STORAGE/raw/master/7za.exe 2>nul
if exist "MultiMC\MultiMC.exe" goto SkipMMC
echo [96mDownloading MultiMC . . .[0m
curl -LJO https://files.multimc.org/downloads/mmc-stable-win32.zip --progress-bar
echo [96mExtracting . . .[0m
call 7za.exe x mmc-stable-win32.zip >nul
md MultiMC\Instances\
:SkipMMC
echo [96mDownloading and Creating Instances . . .[0m
curl ftp://mc.itcommand.net:21/LatestInstall.zip --user "mcupdate:MCUpdate@32" -o "LatestInstall.zip" --progress-bar
cd MultiMC\Instances
call ..\..\7za.exe x ..\..\LatestInstall.zip >nul 2>nul
cd ..\..
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
echo If you do not have x64 Java installed, Install it BEFORE pressing any key.
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
call "MultiMC\MultiMC.exe" >nul 2>nul
cls
echo.
echo You finished the setup. You can change these settings later form the main menu.
echo.
echo FNS will now download the latest modpacks.
timeout /t 5
endlocal
goto restartall




:mainmenu
cls
call :loading
call Loadingstar.exe --command "Load.bat" 
for /f "tokens=*" %%A in (set.ini) do (set %%~A)
del /f /q set.ini
if exist 7za.exe del /f /q 7za.exe
:mainmenuskipload
cls
title Friends N Such Minecraft Launcher
echo ========================================================================
echo [32m            .-/ss+:.
echo [32m        .:+shyyyyyyo/-`       
echo [32m   `.:+syyyyyyyyyyyhyyso/-`       
echo [32m  oyyyhhyyyyyyyyyyyyhyyyyyys:     [92;7m Friends N Such Minecraft [0;90m
echo [90m  hhh[32myyyyyyyyyyyyyyyyyyhhh[90mmdo     [90m[===  By  SystemInfo  ===][0m
echo [90m  hhhyhh[32mdyyyyyyyyhyhhdd[90mddmddd     [0mVersion:  %ver% [[90m%status%[0m][90m
echo [90m  hhyhhdhhh[32mhhhhhhddd[90mdmdddddd+     [0mServer:   play.itcommand.net[90m
echo %statline1%
echo %statline2%
echo %statline3%
echo   oyyhhyhhyhyyyhhdhhhdddddhy/     [0mPrimary Players: [7m!players![0;90m
echo    `./oyyyyhhyyhddddddhs+:`       [0mExplore Players: [7m!expplayers![0;90m
echo        `.:oyyyyhddhy+:`       
echo            `-/syo:.``             Main Menu[0m
echo ========================================================================
echo 1] Launch Game
echo E] Open FNS Explorer Menu [96m(New^^!)[0m
echo 2] Export Config [90m(Sensitivity, graphics, shader settings)[0m
echo 3] Import Config
echo 4] Reset Mods (Re-Downloads All Mods)
echo 5] Reset Instances (Removes all Instances and Config).
echo 6] Full Reset (Reinstalls MultiMC and Instances / Config).
echo 7] Open MultiMC menu [90m(Settings, accounts)[0m
echo 8] [96mToggle Better Foliage [90m(Unavailable for 1.18.2)[0m
echo 9] Open Latest Log
echo H] Help Files
echo [90mX] Exit ^| [R] Refresh[0m
echo.
choice /c 123456789XLERH
if %errorlevel%==1 goto launch
if %errorlevel%==2 goto expcfg
if %errorlevel%==3 goto impcfg
if %errorlevel%==4 goto resmods
if %errorlevel%==5 goto resetint
if %errorlevel%==6 goto fullreset
if %errorlevel%==7 goto justmultimc
if %errorlevel%==9 start "" "MultiMC\Instances\Friends N Such\.minecraft\logs\latest.log"
if %errorlevel%==10 goto exit
if %errorlevel%==11 start https://mc.itcommand.net:8056
if %errorlevel%==12 goto explorer
if %errorlevel%==13 (
		call :loading
		goto mainmenu
)
if %errorlevel%==14 goto help
goto mainmenu

:help
cls
echo HELP Menu
echo ========================================================================
echo.
echo 1] How to Update Forge
echo 2] More coming soon.
echo X] Back to menu
echo.
choice /c 123456789X
if %errorlevel%==1 (
	start https://github.com/ITCMD/Friends-N-Such-Launcher/blob/main/Updating%%20Forge.pdf
)
goto mainmenu
	

:refreshexplorer
cls
echo [0m========================================================================
echo [96m            .-/ss+:.
echo [96m        .:+shyyyyyyo/-`       
echo [96m   `.:+syyyyyyyyyyyhyyso/-`       
echo [96m  oyyyhhyyyyyyyyyyyyhyyyyyys:     [96;7m Friends N Such Minecraft [0;90m
echo [90m  hhh[96myyyyyyyyyyyyyyyyyyhhh[90mmdo     
echo [90m  hhhyhh[96mdyyyyyyyyhyhhdd[90mddmddd 
echo [90m  hhyhhdhhh[96mhhhhhhddd[90mdmdddddd+ 
echo [90m  yyyyhdddhhh[96mhhddd[90mddddmdhdddo
echo [90m  hhyyyhyhhhmh[96mhhd[90mhhddhhdhhhdo         [96mQuerying Servers...
echo [90m  hhhyyyhyyhyhyhdhdddhdhddhh+
echo   oyyhhyhhyhyyyhhdhhhdddddhy/  
echo    `./oyyyyhhyyhddddddhs+:`      
echo        `.:oyyyyhddhy+:`       
echo            `-/syo:.`` 
echo [0m========================================================================
echo.
echo|set /p=.                            Loading . . .  
call Loadingstar.exe --command "Load.bat" 
for /f "tokens=*" %%A in (set.ini) do (set %%~A)
del /f /q set.ini
:explorer
cls
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
echo %statline1b%
echo %statline2b%
echo %statline3%
if exist exploreplayers.txt del /f /q exploreplayers.txt
echo   oyyhhyhhyhyyyhhdhhhdddddhy/     [0mPrimary Players:  [7m!players![0;90m
echo    `./oyyyyhhyyhddddddhs+:`       [0mExplore Players:  [7m!expplayers![0;90m
echo        `.:oyyyyhddhy+:`     
echo            `-/syo:.``             Explorer Menu[0m  Port: 25567
echo [0m========================================================================
echo [0m1] Launch Exploring Instance
echo 2] Import Config
echo 3] Reset all Mods
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
	rmdir /s /q "MultiMC\Instances\FNS Exploring\.minecraft\mods" 
	mkdir "MultiMC\Instances\FNS Exploring\.minecraft\mods"
	rmdir /s /q "MultiMC\Instances\FNS Exploring\.minecraft\config" 
	mkdir "MultiMC\Instances\FNS Exploring\.minecraft\config"
	endlocal
	goto restartall
)
if %errorlevel%==4 goto 2betterfexp
if %errorlevel%==6 goto :mainmenuskipload
if %errorlevel%==7 goto refreshexplorer

goto explorer



rem this has to be here because windows.

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





:2betterfexp
cls
if exist "MultiMC\Instances\FNS Exploring\.minecraft\mods\BetterFoliage*" (
	echo Mod is currently enabled.
	echo Disable?
	choice
	if !errorlevel!==1 del /f /q "MultiMC\Instances\FNS Exploring\.minecraft\mods\BetterFoliage*"
	goto explorer
)
echo Mod is currently Disabled.
echo Enable?
choice
if %errorlevel%==2 goto explorer
curl -LJO %betterfoliageurl% >nul 2>nul
move "BetterFoliage*" "MultiMC\Instances\FNS Exploring\.minecraft\mods\" >nul
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


:mustreset
cls
echo The latest update of Friends N Such requires a fresh reset of both the Friends N Such and the Explorer Instances.
echo.
echo It is recommended that you do NOT carry and config over, as mods and config menues have changed.
echo.
echo Please copy any screenshots or resourcepacks you would like to save out of the following two folders:
echo.
echo %cd%\MultiMC\Instances\Friends N Such\.minecraft
echo %cd%\MultiMC\Instances\Explorer\.minecraft
echo.
pause
goto forceresetint


:resetint
cls
echo This will reset both the Primary and Explorer server's instances.
echo You will lose any config you have saved.
echo Are you sure?
choice
if %errorlevel%==2 goto mainmenu
:forceresetint
cls
echo [96mResetting Instance . . .
taskkill /f /im javaw.exe >nul 2>nul
rmdir /s /q "MultiMC\Instances\Friends N Such"
rmdir /s /q "MultiMC\Instances\FNS Exploring"
goto :SkipMMC


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
del /f /q "MultiMC\Instances\Friends N Such\.minecraft\mods\*"
timeout /t 2 >nul
endlocal
goto restartall


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


:ftpls
set session=%random%%random%%random%
rem USAGE: call with 4 parameters
rem ftpls hostname USER PASS path/on/remote/machine
set "script=%TEMP%\ftpscript%session%.txt"
set "output=%TEMP%\ftplist%session%.txt"
set "host=%1"
set "user=%2"
set "pass=%3"
set "dir=%4"
>  "%script%" echo open %host%
>> "%script%" echo user %user%
>> "%script%" echo %pass%
>> "%script%" echo cd %dir%
>> "%script%" echo ls * %output%
>> "%script%" echo bye
ftp -n -s:"%script%" >nul
rem modify "skip" and "tokens" to select the right lines and columns
del "%script%"
exit /b






	