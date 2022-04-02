@echo off
Setlocal EnableDelayedExpansion
goto test
:mainmenu
cls
echo 1] Primary
echo 2] Explore
echo X] Cancel
choice /C 12x
if %errorlevel%==1 goto updateprime
if %errorlevel%==2 goto updateexplore
if %errorlevel%==3 exit /b

:updateprime
cls
echo Enter version number
set /p version=">"
MCUpdate@32




:test
call :ftpls ftp.itcommand.net mcupdate MCUpdate@32 /ExplorerClient
pause

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
type "%output%"
del "%script%"
del "%output%"