@echo off
title WSA Link Fixer
cd /d "%~dp0"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0WSA_Link_Fixer.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] An error occurred while executing the script.
    pause
)
