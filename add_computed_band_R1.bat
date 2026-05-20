@echo off
setlocal enabledelayedexpansion

REM Path to carisbatch.exe
set "carisBatch=C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"

REM Prompt user for CSAR folder path
set /p folder=Enter the path to your CSAR folder: 

REM Band 1 parameters
set "band1Name=Depth_TPU_Compliance"
set "band1Expr=((0.5 ^ 2 + (0.013*Depth) ^ 2) ^ 0.5) - Depth_TPU"
set "band1Type=Numeric"

REM Band 2 parameters
set "band2Name=Position_TPU_Compliance"
set "band2Expr=(5 + (Depth * 0.05)) - Position_TPU"
set "band2Type=Numeric"

for %%F in ("%folder%\*.csar") do (
    echo Processing: %%F
    REM Add first computed band
    "%carisBatch%" --run AddComputedBand --compute-band "%band1Name%" --expression "%band1Expr%" --z-axis-convention DOWN --computed-band-type "%band1Type%" "%%F"
    REM Add second computed band
    "%carisBatch%" --run AddComputedBand --compute-band "%band2Name%" --expression "%band2Expr%" --z-axis-convention DOWN --computed-band-type "%band2Type%" "%%F"
)

echo Done.
pause
