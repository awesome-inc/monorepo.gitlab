@echo off
setlocal
set folder=%1
set ref=%LAST_GREEN_COMMIT%
if "%ref%"=="" set ref=HEAD~

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
