@echo off
setlocal enabledelayedexpansion

REM Prompt for CSAR folder
set /p CSAR_DIR="Enter the folder path containing CSAR files: "

REM Prompt for WKT folder
set /p SHP_DIR="Enter the folder path containing WKT files: "

REM Output folder (optional, or use CSAR folder)
set /p OUT_DIR="Enter the output folder for extracted surfaces: "

REM Loop through CSAR files

for %%C in ("%CSAR_DIR%\*.csar") do (
    set "FILENAME=%%~nC"
    set "GEOM_FILE=%SHP_DIR%\!FILENAME!.wkt"
    if exist "!GEOM_FILE!" (
        set "OUT_FILE=%OUT_DIR%\!FILENAME!_extracted.csar"
        echo Running ExtractCoverage for !FILENAME!
        "C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe" --run ExtractCoverage --geometry-file "!GEOM_FILE!" --include-band ALL "%%C" "!OUT_FILE!"
    ) else (
        echo No matching WKT for !FILENAME!.csar, skipping.
    )
)

echo Done.
pause
