@echo off
cd /d "%~dp0"
where py >nul 2>nul
if errorlevel 1 (
  python SIGN_R783.py %*
) else (
  py -3 SIGN_R783.py %*
)
pause
