@echo off

if "%1"=="--help" (
  echo %~n0 [--help] [--version] [--length n] [--lower n] [--upper n] [--digit n] [--special n] [--chars "-_"]
  echo.
  echo A very simple and flexible password generator
  echo.
  echo Available parameters:
  echo.
  echo --length   Password length, maximum 100
  echo --lower    Minimum number of lowercase letters
  echo --upper    Minimum number of uppercase letters
  echo --digit    Minimum number of digits
  echo --special  Minimum number of special characters
  echo --chars    Allowable special characters
  echo.
  echo --lower, --upper, --digit and --special must specify an integer ^>= 0 ^(0 meaning 'not allowed'^).
  echo.
  echo Defaults are equivalent to:
  echo.
  echo %~n0 --length 12 --lower 1 --upper 1 --digit 1 --special 1 --chars "-_"
  goto :eof
)
if "%1"=="--version" (
  echo v1.4.1 2024-10-20 JMS
  goto :eof
)

rem From https://stackoverflow.com/questions/3551888/pausing-a-batch-file-when-double-clicked-but-not-when-run-from-a-console-window 2017-08-16 JMS (see below)
echo %CMDCMDLINE% | findstr /i /c:"%~nx0">nul && set standalone=1

setlocal EnableDelayedExpansion
set dpn0=%~dpn0

:loop
if "%~1"=="" goto doit
set value=%1
if "!value:~0,2!"=="--" (
  set name=!value:~2!
) else (
  if not "!name!"=="" (
    if "!name!"=="chars" (
      set "chars=%~1"&set name=
    ) else (
      set /a number=%1
      if "!number!" == "%1" (
        if "!name!"=="length" set length=%1
        if "!name!"=="lower" set lower=%1
        if "!name!"=="upper" set upper=%1
        if "!name!"=="digit" set digit=%1
        if "!name!"=="special" set special=%1
      )
    )
  )
)
shift
goto loop

:doit
set "parameters="
if not "!length!"=="" set "parameters=!parameters! -length !length!"
if not "!lower!"=="" set "parameters=!parameters! -lower !lower!"
if not "!upper!"=="" set "parameters=!parameters! -upper !upper!"
if not "!digit!"=="" set "parameters=!parameters! -digit !digit!"
if not "!special!"=="" set "parameters=!parameters! -special !special!"
if not "!chars!"=="" set "parameters=!parameters! -chars '!chars!'"
call powershell -ExecutionPolicy Unrestricted -Command "& !dpn0!.ps1 !parameters!"
endlocal

rem From https://stackoverflow.com/questions/3551888/pausing-a-batch-file-when-double-clicked-but-not-when-run-from-a-console-window 2017-08-16 JMS (see above)
if defined standalone pause
