@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Serveur Local - Clone Website

set "HOST=opurent.localhost"
set /a PORT=5678
set /a MAX_PORT=5800

:find_free_port
netstat -ano | findstr /R /C:":!PORT! .*LISTENING" >nul
if not errorlevel 1 (
    set /a PORT+=1
    if !PORT! GTR !MAX_PORT! (
        echo Aucun port libre entre 5678 et !MAX_PORT!.
        pause
        exit /b 1
    )
    goto find_free_port
)

echo ------------------------------------------------
echo    DEMARRAGE DU SERVEUR LOCAL
echo ------------------------------------------------
echo Port local choisi: !PORT!

start "" "http://%HOST%:!PORT!"

python -m http.server !PORT!
if !errorlevel! neq 0 (
    py -m http.server !PORT!
    if !errorlevel! neq 0 (
        php -S 0.0.0.0:!PORT!
        if !errorlevel! neq 0 (
            echo.
            echo Erreur: Python ou PHP est requis pour lancer le serveur local.
            pause
            )
        )
)
