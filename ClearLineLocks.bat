@echo off
setlocal enabledelayedexpansion

echo === ClearLineLocks Batch Script ===

REM Prompt for parent folder
set /p parent_folder=Enter the parent folder to search for .hips files (Will check subfolders): 
if not exist "%parent_folder%" (
    echo Folder not found. Exiting.
    pause
    exit /b
)

REM Prompt for exe path
set /p exe_path=Enter the FULL path to the clear_HIPS_line_locks.exe file to run: 
REM Remove surrounding quotes from exe_path if present
set exe_path=%exe_path:"=%
if not exist "%exe_path%" (
    echo EXE not found. Exiting.
    pause
    exit /b
)

set "output_file=%parent_folder%\LineLock_Removal_Summary.txt"
if exist "%output_file%" del "%output_file%"

REM Find and process all .hips files recursively
set count=0
set found_any=false
for /r "%parent_folder%" %%F in (*.hips) do (
    set found_any=true
    set /a count+=1
    echo --- Output for: %%F --- >> "%output_file%"
    "%exe_path%" "%%F" >> "%output_file%" 2>&1
    echo --- End of output --- >> "%output_file%"
)

if not !found_any!==true (
    echo No .hips files found in %parent_folder% or subfolders.
) else (
    echo Processing complete. Output saved to: %output_file%
)

echo === Script Complete ===
pause
