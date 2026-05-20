Write-Host "=== ClearLineLocks PowerShell Script ==="

# Prompt for parent folder
$parent_folder = Read-Host "Enter the parent folder to search for .hips files (Will check subfolders)"
if (-not (Test-Path $parent_folder)) {
    Write-Host "Folder not found. Exiting."
    Pause
    exit
}

# Prompt for exe path
$exe_path = Read-Host "Enter the FULL path to the clear_HIPS_line_locks.exe file to run"
$exe_path = $exe_path.Trim('"')
if (-not (Test-Path $exe_path)) {
    Write-Host "EXE not found. Exiting."
    Pause
    exit
}

$output_file = Join-Path $parent_folder "LineLock_Removal_Summary.txt"
if (Test-Path $output_file) { Remove-Item $output_file }

# Find and process all .hips files recursively
$hips_files = Get-ChildItem -Path $parent_folder -Recurse -Filter *.hips
if ($hips_files.Count -eq 0) {
    Write-Host "No .hips files found in $parent_folder or subfolders."
} else {
    $count = 0
    foreach ($file in $hips_files) {
        $count++
        Add-Content -Path $output_file -Value "--- Output for: $($file.FullName) ---"
        $exeOutput = & $exe_path $file.FullName
        Add-Content -Path $output_file -Value $exeOutput
        Add-Content -Path $output_file -Value "--- End of output ---"
    }
    Write-Host "Processing complete. Output saved to: $output_file"
}

Write-Host "=== Script Complete ==="
Pause
