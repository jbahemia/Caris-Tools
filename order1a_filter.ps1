# Prompt for parent folder
$parentFolder = Read-Host "Enter the path to the parent folder"

# Check if folder exists
if (-not (Test-Path $parentFolder -PathType Container)) {
    Write-Host "Folder does not exist."
    exit 1
}

# Set CARIS batch executable path
$carisbatch = 'C:\Program Files\CARIS\HIPS and SIPS\11.4\bin\carisbatch.exe'

# Set CARIS options
$bathymetryType = 'SWATH'
$ihoOrder = 'S44_1A'
# Add more options as needed, e.g.:
# $options = '--accept-data --protective-radius 5'

# Find and process all .hips files recursively
Get-ChildItem -Path $parentFolder -Recurse -Filter *.hips | ForEach-Object {
    $hipsFile = $_.FullName
    Write-Host "Processing: $hipsFile"
    & $carisbatch --run FilterObservedDepths --bathymetry-type $bathymetryType --iho-order $ihoOrder "$hipsFile"
}

Write-Host "Done."
Read-Host "Press Enter to exit..."
