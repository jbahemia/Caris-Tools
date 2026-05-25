@echo off
setlocal enabledelayedexpansion

REM Prompt for parent folder
set /p parentFolder=Enter the path to the parent folder: 

REM Check if folder exists
if not exist "%parentFolder%" (
    echo Folder does not exist.
    exit /b 1
)

REM Set CARIS batch executable path
set carisbatch="C:\Program Files\CARIS\HIPS and SIPS\11.4\bin\carisbatch.exe"

REM Set your CARIS options here
set bathymetryType=SWATH
set ihoOrder=S44_1A
REM Add more options as needed, e.g.:
REM set options=--accept-data --protective-radius 5

REM Find and process all .hips files
for /r "%parentFolder%" %%F in (*.hips) do (
    echo Processing: %%F
    %carisbatch% --run FilterObservedDepths --bathymetry-type %bathymetryType% --iho-order %ihoOrder% "%%F"
)

echo Done.
pause
