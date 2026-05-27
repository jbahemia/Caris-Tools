
# Prompt for file or folder
$inputPath = Read-Host "Enter the path to a .hips file or parent folder"
# Remove quotes if present
$inputPath = $inputPath -replace '^[\"]*(.*?)[\"]*$', '$1'
# Trim leading/trailing spaces
$inputPath = $inputPath.Trim()

# Check if path exists
if (-not (Test-Path $inputPath)) {
    Write-Host "Path does not exist."
    exit 1
}

# Set CARIS batch executable path
$carisbatch = 'C:\Program Files\CARIS\HIPS and SIPS\11.4\bin\carisbatch.exe'

# Set CARIS options
$bathymetryType = 'SWATH'
$ihoOrder = 'S44_1A'
# Add more options as needed, e.g.:
# $options = '--accept-data --protective-radius 5'


if (Test-Path $inputPath -PathType Container) {
    # It's a folder, process all .hips files recursively
    Get-ChildItem -Path $inputPath -Recurse -Filter *.hips | ForEach-Object {
        $hipsFile = $_.FullName
        Write-Host "Processing: $hipsFile"
        & $carisbatch --run FilterObservedDepths --bathymetry-type $bathymetryType --iho-order $ihoOrder "$hipsFile"
    }
} else {
    # It's a file, process just that file
    Write-Host "Processing: $inputPath"
    & $carisbatch --run FilterObservedDepths --bathymetry-type $bathymetryType --iho-order $ihoOrder "$inputPath"
}

Write-Host "Done."
Read-Host "Press Enter to exit..."
