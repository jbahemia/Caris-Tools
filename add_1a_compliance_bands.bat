@echo off
setlocal enabledelayedexpansion

REM Path to carisbatch.exe
set "carisBatch=C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"


REM Prompt user for CSAR folder or file path
set /p inputPath=Enter the path to your CSAR folder or a single CSAR file: 
REM Strip quotes if present
set inputPath=%inputPath:"=%

REM Band 1 parameters
set "band1Name=Depth_TPU_Compliance"
set "band1Expr=(((0.5 ^ 2 + (0.013*Depth) ^ 2) ^ 0.5) - Depth_TPU)"
set "band1Type=Numeric"

REM Band 2 parameters
set "band2Name=Position_TPU_Compliance"
set "band2Expr=((5 + (Depth * 0.05)) - Position_TPU)"
set "band2Type=Numeric"


REM Check if inputPath is a file or directory
if exist "%inputPath%" (
    if exist "%inputPath%\" (
        REM It's a directory, process all .csar files in the folder
        for %%F in ("%inputPath%\*.csar") do (
            echo Processing: %%F
            REM Add first computed band
            "%carisBatch%" --run AddComputedBand --compute-band "%band1Name%" --expression "%band1Expr%" --z-axis-convention DOWN --computed-band-type "%band1Type%" "%%F"
            REM Add second computed band
            "%carisBatch%" --run AddComputedBand --compute-band "%band2Name%" --expression "%band2Expr%" --z-axis-convention DOWN --computed-band-type "%band2Type%" "%%F"
        )
    ) else (
        REM It's a file, process just that file
        echo Processing: %inputPath%
        "%carisBatch%" --run AddComputedBand --compute-band "%band1Name%" --expression "%band1Expr%" --z-axis-convention DOWN --computed-band-type "%band1Type%" "%inputPath%"
        "%carisBatch%" --run AddComputedBand --compute-band "%band2Name%" --expression "%band2Expr%" --z-axis-convention DOWN --computed-band-type "%band2Type%" "%inputPath%"
    )
) else (
    echo The path does not exist.
    pause
    exit /b 1
)

echo Done.
pause
