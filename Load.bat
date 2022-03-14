rem statline host
curl ftp://mc.itcommand.net:21/players.txt --user "mcplayers:mojang" -o players.txt >nul 2>nul
if %errorlevel%==0 (
	set statline1=[90m  yyyyhdddhhh[32mhhddd[90mddddmdhdddo     [0mStatus:   [32mHost Online[90m
    set statline1b=[90m  yyyyhdddhhh[96mhhddd[90mddddmdhdddo     [0mStatus:   [32mHost Online[90m
	curl ftp://mc.itcommand.net:21/explore/players.txt --user "mcplayers:mojang" -o exploreplayers.txt >nul 2>nul
) ELSE (
	set statline1=[90m  yyyyhdddhhh[32mhhddd[90mddddmdhdddo     [0mStatus:   [91mHost No Reply[90m
	set statline1b=[90m  yyyyhdddhhh[96mhhddd[90mddddmdhdddo     [0mStatus:   [91mHost No Reply[90m
	echo.>players.txt
)
rem statline main
curl -LJ https://api.mcsrvstat.us/2/play.itcommand.net:25565 -o stat.json 2>nul
if not "%errorlevel%"=="0" (
	set statline2=[90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo     [0mStatus:   Unknown
	set statline2b=[90m  hhyyyhyhhhmh[96mhhd[90mhhddhhdhhhdo     [0mStatus:   Unknown
	goto skipstatus
)
find ",""online"":true,""" "stat.json" >nul 2>nul
if %errorlevel%==0 (
	set statline2=[90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo     [0mPrimary:  [32mServer Online[90m
	set statline2b=[90m  hhyyyhyhhhmh[96mhhd[90mhhddhhdhhhdo     [0mPrimary:  [32mServer Online[90m
) ELSE (
	set statline2=[90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo     [0mPrimary:  [91mServer Offline[90m
	set statline2b=[90m  hhyyyhyhhhmh[96mhhd[90mhhddhhdhhhdo     [0mPrimary:  [91mServer Offline[90m
	set offline=true
)
:skipstatus
rem statline exp
curl -LJ https://api.mcsrvstat.us/2/mc.itcommand.net:25567 -o stat2.json 2>nul
if not "%errorlevel%"=="0" (
	set statline3=[90m  hhyyyhyhhhmh[32mhhd[90mhhddhhdhhhdo     [0mStatus:   Unknown
	set statline3b=[90m  hhyyyhyhhhmh[96mhhd[90mhhddhhdhhhdo     [0mStatus:   Unknown
	goto skip2status
)
find ",""online"":true,""" "stat2.json" >nul 2>nul
if %errorlevel%==0 (
	set statline3=[90m  hhhyyyhyyhyhyhdhdddhdhddhh+     [0mExplore:  [32mServer Online[90m
) ELSE (
	set statline3=[90m  hhhyyyhyyhyhyhdhdddhdhddhh+     [0mExplore:  [91mServer Offline[90m
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
set stat>>set.ini
set offline>>set.ini
set exp>>set.ini
set play>>set.ini
exit /b