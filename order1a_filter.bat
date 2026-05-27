@echo off
setlocal enabledelayedexpansion


set /p inputPath=Enter the path to a .hips file or a folder containing .hips files: 
REM Remove quotes if present

REM Remove quotes if present
set inputPath=%inputPath:"=%
set inputPath=%inputPath:'=%

REM Trim leading/trailing spaces
for /f "tokens=*" %%A in ("%inputPath%") do set inputPath=%%A

REM Check if path exists
if not exist "%inputPath%" (
    echo Path does not exist.
    exit /b 1
)

REM Set CARIS batch executable path
set carisbatch="C:\Program Files\CARIS\HIPS and SIPS\11.4\bin\carisbatch.exe"

REM Set your CARIS options here
set bathymetryType=SWATH
set ihoOrder=S44_1A
REM Add more options as needed, e.g.:
REM set options=--accept-data --protective-radius 5


REM Check if input is a file or folder
if exist "%inputPath%\\" (
    REM It's a folder, process all .hips files recursively
    for /r "%inputPath%" %%F in (*.hips) do (
        echo Processing: %%F
        %carisbatch% --run FilterObservedDepths --bathymetry-type %bathymetryType% --iho-order %ihoOrder% "%%F"
    )
) else if exist "%inputPath%" (
    REM It's a file, process just that file
    echo Processing: %inputPath%
    %carisbatch% --run FilterObservedDepths --bathymetry-type %bathymetryType% --iho-order %ihoOrder% "%inputPath%"
) else (
    echo Path does not exist.
    exit /b 1
)

echo Done.
pause
