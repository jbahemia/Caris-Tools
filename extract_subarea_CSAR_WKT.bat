@echo off
setlocal enabledelayedexpansion

REM Prompt for CSAR folder

set /p inputPath=Enter the path to a CSAR file or folder containing CSAR files: 
set inputPath=%inputPath:"=%
set inputPath=%inputPath:'=%
set /p wktInput=Enter the path to a WKT file (for single CSAR) or folder containing WKT files: 
set wktInput=%wktInput:"=%
set wktInput=%wktInput:'=%
set /p OUT_DIR=Enter the output folder for extracted surfaces: 
set OUT_DIR=%OUT_DIR:"=%
set OUT_DIR=%OUT_DIR:'=%

REM Check if inputPath is a file or directory
if exist "%inputPath%" (
    if exist "%inputPath%\\" (
        REM It's a directory, process all .csar files in the folder
        REM Check if wktInput is a file or folder
        if exist "%wktInput%\\" (
            REM WKT is a folder, match by name
            for %%C in ("%inputPath%\*.csar") do (
                set "FILENAME=%%~nC"
                set "GEOM_FILE=%wktInput%\!FILENAME!.wkt"
                if exist "!GEOM_FILE!" (
                    set "OUT_FILE=%OUT_DIR%\!FILENAME!_extracted.csar"
                    echo Running ExtractCoverage for !FILENAME!
                    "C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe" --run ExtractCoverage --geometry-file "!GEOM_FILE!" --include-band ALL "%%C" "!OUT_FILE!"
                ) else (
                    echo No matching WKT for !FILENAME!.csar, skipping.
                )
            )
        ) else (
            REM WKT is a file, only process CSAR with matching base name
            REM Only call subroutine if CSAR base name matches WKT base name
            set "_wktPath=%wktInput%"
            set "_outPath=%OUT_DIR%"
            for %%C in ("%inputPath%\*.csar") do (
                for %%W in ("!_wktPath!") do (
                    if not "%%~nC"=="" if not "%%~nW"=="" if /I "%%~nC"=="%%~nW" call :processSingleWKT "%%C" "!_wktPath!" "!_outPath!"
                )
            )
        )
    ) else (
        REM It's a file, process just that file
        REM Check if wktInput is a folder or file
        if exist "%wktInput%\\" (
            REM WKT is a folder, match by name - inline logic to avoid argument passing issues with spaces
            set "_csarFile=!inputPath!"
            set "_wktPath=!wktInput!"
            set "_outPath=!OUT_DIR!"
            for %%I in ("!inputPath!") do set "_fileName=%%~nI"
            set "_geomFile=!_wktPath!\!_fileName!.wkt"
            set "_outFile=!_outPath!\!_fileName!_extracted.csar"
            if exist "!_geomFile!" (
                echo Running ExtractCoverage for !_fileName!
                "C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe" --run ExtractCoverage --geometry-file "!_geomFile!" --include-band ALL "!_csarFile!" "!_outFile!"
            ) else (
                echo No matching WKT for !_csarFile!, skipping.
            )
        ) else (
            REM WKT is a file, use directly
            set "GEOM_FILE=%wktInput%"
            set GEOM_FILE=!GEOM_FILE:"=!
            set GEOM_FILE=!GEOM_FILE:'=!
            for %%I in ("%inputPath%") do set "FILENAME=%%~nI" & set "OUT_FILE=%OUT_DIR%\%%~nI_extracted.csar"
            if exist "!GEOM_FILE!" (
                echo Running ExtractCoverage for !FILENAME!
                "C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe" --run ExtractCoverage --geometry-file "!GEOM_FILE!" --include-band ALL "%inputPath%" "!OUT_FILE!"
            ) else (
                echo WKT file not found: "!GEOM_FILE!"
            )
        )
    )
) else (
    echo The path does not exist.
    pause
    exit /b 1
)

echo Done.
pause
goto :eof

REM ========== SUBROUTINES ==========

:processSingleWKT
setlocal enabledelayedexpansion
set "CSAR=%~1"
set "WKT=%~2"
set "OUTDIR=%~3"
for %%I in ("!CSAR!") do set "FILENAME=%%~nI"
for %%W in ("!WKT!") do set "WKTNAME=%%~nW"
set "GEOM_FILE=!WKT!"
set GEOM_FILE=!GEOM_FILE:"=!
set GEOM_FILE=!GEOM_FILE:'=!
REM Trim trailing spaces from GEOM_FILE
for /f "tokens=*" %%T in ("!GEOM_FILE!") do set GEOM_FILE=%%T
set "OUT_FILE=!OUTDIR!\!FILENAME!_extracted.csar"
if /I "!FILENAME!"=="!WKTNAME!" (
    if exist "!GEOM_FILE!" (
        echo Running ExtractCoverage for !FILENAME! (using single WKT)
        "C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe" --run ExtractCoverage --geometry-file "!GEOM_FILE!" --include-band ALL "!CSAR!" "!OUT_FILE!"
    ) else (
        echo WKT file not found: !GEOM_FILE!
    )
)
endlocal
goto :eof

:processSingleCSAR_WKTFolder
setlocal enabledelayedexpansion
set "CSAR=%~1"
set "WKT_FOLDER=%~2"
set "OUTDIR=%~3"
for %%I in ("!CSAR!") do set "FILENAME=%%~nI"
set "GEOM_FILE=!WKT_FOLDER!\!FILENAME!.wkt"
set "OUT_FILE=!OUTDIR!\!FILENAME!_extracted.csar"
if exist "!GEOM_FILE!" (
    echo Running ExtractCoverage for !FILENAME!
    echo. > "%TEMP%\_csar_wkt_match.flag"
    "C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe" --run ExtractCoverage --geometry-file "!GEOM_FILE!" --include-band ALL "!CSAR!" "!OUT_FILE!"
)
endlocal
goto :eof
