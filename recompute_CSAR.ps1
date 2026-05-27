# Recompute_CSAR.ps1
# Prompts for a folder and runs RecomputeHIPSGrid on all .csar files in that folder using CARIS HIPS and SIPS 11.4


# Prompt for file or folder
$inputPath = Read-Host "Enter the path to a .csar file or a folder containing .csar files"
# Remove quotes if present
$inputPath = $inputPath -replace '^[\"]*(.*?)[\"]*$', '$1'
# Trim leading/trailing spaces
$inputPath = $inputPath.Trim()

$carisBatch = "C:\Program Files\CARIS\HIPS and SIPS\11.4\bin\carisbatch.exe"

if (-not (Test-Path $inputPath)) {
    Write-Host "Path does not exist: $inputPath" -ForegroundColor Red
    exit 1
}

if (Test-Path $inputPath -PathType Container) {
    # It's a folder, process all .csar files in the folder
    $csarFiles = Get-ChildItem -Path $inputPath -Filter *.csar
    if ($csarFiles.Count -eq 0) {
        Write-Host "No CSAR files found in $inputPath" -ForegroundColor Yellow
        exit 0
    }
    foreach ($file in $csarFiles) {
        Write-Host "Running RecomputeHIPSGrid on $($file.FullName)"
        & $carisBatch --run RecomputeHIPSGrid "$($file.FullName)"
    }
} else {
    # It's a file, process just that file
    Write-Host "Running RecomputeHIPSGrid on $inputPath"
    & $carisBatch --run RecomputeHIPSGrid "$inputPath"
}

Write-Host "Done."
