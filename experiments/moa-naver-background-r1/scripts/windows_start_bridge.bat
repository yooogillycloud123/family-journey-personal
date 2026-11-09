@echo off
cd /d "%~dp0.."
python -m moa_naver_bridge.cli token
python -m moa_naver_bridge.cli serve
pause
