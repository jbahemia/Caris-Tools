@echo off
setlocal enabledelayedexpansion

echo Exporting CUBE surfaces only (Depth, Uncertainty bands)
set /p folder=Enter the path to the folder containing CSAR files: 

set carisBatch="C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"

for %%F in ("%folder%\*.csar") do (
    set "input=%%F"
    set "output=%%~dpnF.bag"
    set "basename=%%~nF"
    echo Exporting raster: !input! to !output! with band Depth
    call %carisBatch% --run ExportRaster --output-format BAG --include-band Depth --uncertainty Uncertainty --abstract "!basename!" --legal-constraints RESTRICTED --notes "!basename!" --party-organization "Cyan" --security-constraints RESTRICTED --status COMPLETED --uncertainty-type PRODUCT_UNCERT --vertical-datum "LAT" --party-role PUBLISHER "!input!" "!output!"
)

echo Done!
pause
