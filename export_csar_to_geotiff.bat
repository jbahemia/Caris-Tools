@echo off
setlocal enabledelayedexpansion

set /p type=Type CUBE or SDTP to select surface type: 
set /p folder=Enter the path to the folder containing CSAR files: 
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

for %%F in ("%folder%\*.csar") do (
    set "input=%%F"
    set "output=%%~dpnF.tif"
    echo Processing !input! to !output! with bands: !bands!
    call %carisBatch% --run ExportRaster --output-format GEOTIFF !bands! "!input!" "!output!"
)

echo Done!
pause
