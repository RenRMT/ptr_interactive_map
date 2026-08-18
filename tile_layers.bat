@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM CONFIGURE THESE THREE PATHS
REM ============================================================

REM Path to vips.exe
set VIPS=/path/to/vips.exe

REM Folder containing all your layer PNGs (basemap.png, roads.png, etc.)
set INPUT_DIR=/path/to/input_directory

REM Folder where the tiled .dzi + _files folders will be written
set OUTPUT_DIR=/path/to/output_directory

REM JPEG-style quality setting for the PNG tiles (same as your original)
set QUALITY=90

REM ============================================================
REM Shouldn't need to edit below this line
REM ============================================================

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo.
echo Tiling all PNGs in "%INPUT_DIR%"
echo Output going to "%OUTPUT_DIR%"
echo.

set COUNT=0
set FAILCOUNT=0

for %%F in ("%INPUT_DIR%\*.png") do (
    set NAME=%%~nF
    echo -----------------------------------------------------
    echo Tiling !NAME!.png ...

    "%VIPS%" dzsave "%%F" "%OUTPUT_DIR%\!NAME!" --tile-size 256 --overlap 0 --suffix .png[Q=%QUALITY%]

    if errorlevel 1 (
        echo   FAILED: !NAME!.png
        set /a FAILCOUNT+=1
    ) else (
        echo   OK: !NAME!.dzi
        set /a COUNT+=1
    )
)

echo.
echo -----------------------------------------------------
echo Done. !COUNT! layer(s) tiled successfully.
if !FAILCOUNT! gtr 0 (
    echo !FAILCOUNT! layer(s) FAILED - check messages above.
)
echo -----------------------------------------------------
echo.

pause
