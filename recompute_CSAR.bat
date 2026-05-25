@echo off


setlocal enabledelayedexpansion


set /p CSAR_FOLDER=Enter the path to the folder containing CSAR files: 
set carisBatch="C:\Program Files\CARIS\HIPS and SIPS\11.4\bin\carisbatch.exe"


for %%F in ("%CSAR_FOLDER%\*.csar") do (
    echo Running RecomputeHIPSGrid on %%F
    %carisBatch% --run RecomputeHIPSGrid "%%F"
)

echo Done.
