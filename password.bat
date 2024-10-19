@echo off
if "%1"=="--help" (
  rem POSIX fully-portable filenames: A-Z a-z 0-9 - _ .
  echo password [--help] [--version] [--length n] [--lower n] [--upper n] [--digit n] [--special n] [--chars "-_"]
  goto :eof
)
if "%1"=="--version" (
  echo password v1.4.1 2024-10-18 JMS
  goto :eof
)
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
