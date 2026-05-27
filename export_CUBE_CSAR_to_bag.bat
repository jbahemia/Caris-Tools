@echo off
setlocal enabledelayedexpansion

echo Exporting CUBE surfaces only (Depth, Uncertainty bands)
set /p inputPath=Enter the path to a CSAR file or folder containing CSAR files: 
REM Strip quotes if present
set inputPath=%inputPath:"=%

set carisBatch="C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"


REM Check if inputPath is a file or directory
if exist "%inputPath%" (
    if exist "%inputPath%\" (
        REM It's a directory, process all .csar files in the folder
        for %%F in ("%inputPath%\*.csar") do (
            set "input=%%F"
            set "output=%%~dpnF.bag"
            set "basename=%%~nF"
            echo Exporting raster: !input! to !output! with band Depth
            call %carisBatch% --run ExportRaster --output-format BAG --include-band Depth --uncertainty Uncertainty --abstract "!basename!" --legal-constraints RESTRICTED --notes "!basename!" --party-organization "Cyan" --security-constraints RESTRICTED --status COMPLETED --uncertainty-type PRODUCT_UNCERT --vertical-datum "LAT" --party-role PUBLISHER "!input!" "!output!"
        )
    ) else (
        REM It's a file, process just that file
        set "input=%inputPath%"
        set "output=%inputPath:~0,-5%.bag"
        for %%I in ("%inputPath%") do set "basename=%%~nI"
        echo Exporting raster: !input! to !output! with band Depth
        call %carisBatch% --run ExportRaster --output-format BAG --include-band Depth --uncertainty Uncertainty --abstract "!basename!" --legal-constraints RESTRICTED --notes "!basename!" --party-organization "Cyan" --security-constraints RESTRICTED --status COMPLETED --uncertainty-type PRODUCT_UNCERT --vertical-datum "LAT" --party-role PUBLISHER "!input!" "!output!"
    )
) else (
    echo The path does not exist.
    pause
    exit /b 1
)

echo Done!
pause
