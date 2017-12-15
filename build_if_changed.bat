@echo off
setlocal
set folder=%1

call %~dp0changes.bat %folder%
if NOT "%ERRORLEVEL%"=="0" (
  echo Skipping build for '%folder%'.
  exit /B 0
)

echo.
echo Building '%folder%'...
for /f "tokens=1,* delims= " %%a in ("%*") do set command=%%b
echo Executing '%command%'...
echo.
call %command%
set exitCode=%ERRORLEVEL%

exit /B %exitCode%
endlocal
