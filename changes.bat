@echo off
setlocal
set folder=%1
set /P ref=<%~dp0.LAST_GREEN_COMMIT
rem Always indicate changes unless valid green commit ref given, #1
if "%ref%"=="" (
  echo No LAST_GREEN_COMMIT. Assuming changes.
  exit /B 0
)

echo Checking for changes of folder '%folder%' from ref '%ref%'...

call git diff %ref% --name-only | findstr /R "^%folder%" > NUL
set /A changes=%ERRORLEVEL%

if "%changes%"=="0" (
  echo Folder '%folder%' has changed.
) else (
  echo Folder '%folder%' has not changed.
)
exit /B %changes%
endlocal
