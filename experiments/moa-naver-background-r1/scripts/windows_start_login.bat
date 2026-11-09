@echo off
cd /d "%~dp0.."
python -m pip install -e .
python -m playwright install chromium
python -m moa_naver_bridge.cli login
pause
