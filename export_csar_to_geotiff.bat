@echo off
setlocal enabledelayedexpansion

set /p folder=Enter the path to the folder containing CSAR files: 
set carisBatch="C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"

for %%F in ("%folder%\*.csar") do (
    set "input=%%F"
    set "output=%%~dpnF.tif"
    echo Processing "!input!" to "!output!"
    %carisBatch% --run ExportRaster --output-format GEOTIFF --include-band Depth --include-band Density "!input!" "!output!"
)

echo Done!
pause