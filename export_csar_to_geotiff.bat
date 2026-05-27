@echo off
setlocal enabledelayedexpansion

set /p type=Type CUBE or SDTP to select surface type: 
set /p inputPath=Enter the path to a CSAR file or folder containing CSAR files: 
REM Strip quotes if present
set inputPath=%inputPath:"=%
set carisBatch="C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"

set "bands="
if /I "%type%"=="CUBE" (
    set "bands=--include-band Depth --include-band Density --include-band Uncertainty"
    echo CUBE selected. Bands: Depth, Density, Uncertainty
) else if /I "%type%"=="SDTP" (
    set "bands=--include-band Depth --include-band Density --include-band Depth_TPU"
    echo SDTP selected. Bands: Depth, Density, Depth_TPU
) else (
    echo Invalid selection. Please run the script again and type CUBE or SDTP.
    pause
    exit /b
)


REM Check if inputPath is a file or directory
if exist "%inputPath%" (
    if exist "%inputPath%\" (
        REM It's a directory, process all .csar files in the folder
        for %%F in ("%inputPath%\*.csar") do (
            set "input=%%F"
            set "output=%%~dpnF.tif"
            echo Processing !input! to !output! with bands: !bands!
            call %carisBatch% --run ExportRaster --output-format GEOTIFF !bands! "!input!" "!output!"
        )
    ) else (
        REM It's a file, process just that file
        set "input=%inputPath%"
        set "output=%inputPath:~0,-5%.tif"
        echo Processing !input! to !output! with bands: !bands!
        call %carisBatch% --run ExportRaster --output-format GEOTIFF !bands! "!input!" "!output!"
    )
) else (
    echo The path does not exist.
    pause
    exit /b 1
)

echo Done!
pause
