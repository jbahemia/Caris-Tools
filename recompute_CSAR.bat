@echo off


setlocal enabledelayedexpansion



set /p inputPath=Enter the path to a .csar file or a folder containing .csar files: 
REM Remove quotes if present
set inputPath=%inputPath:"=%
set inputPath=%inputPath:'=%
REM Trim leading/trailing spaces
for /f "tokens=*" %%A in ("%inputPath%") do set inputPath=%%A

set carisBatch="C:\Program Files\CARIS\HIPS and SIPS\11.4\bin\carisbatch.exe"

REM Check if path exists
if not exist "%inputPath%" (
    echo Path does not exist.
    exit /b 1
)

REM Check if input is a file or folder
if exist "%inputPath%\\" (
    REM It's a folder, process all .csar files recursively
    for %%F in ("%inputPath%\*.csar") do (
        echo Running RecomputeHIPSGrid on %%F
        %carisBatch% --run RecomputeHIPSGrid "%%F"
    )
) else (
    REM It's a file, process just that file
    echo Running RecomputeHIPSGrid on %inputPath%
    %carisBatch% --run RecomputeHIPSGrid "%inputPath%"
)

echo Done.
