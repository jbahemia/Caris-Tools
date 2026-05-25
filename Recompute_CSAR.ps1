# Recompute_CSAR.ps1
# Prompts for a folder and runs RecomputeHIPSGrid on all .csar files in that folder using CARIS HIPS and SIPS 11.4

$csarFolder = Read-Host "Enter the path to the folder containing CSAR files"
$carisBatch = "C:\Program Files\CARIS\HIPS and SIPS\11.4\bin\carisbatch.exe"

if (-not (Test-Path $csarFolder)) {
    Write-Host "Folder does not exist: $csarFolder" -ForegroundColor Red
    exit 1
}

$csarFiles = Get-ChildItem -Path $csarFolder -Filter *.csar
if ($csarFiles.Count -eq 0) {
    Write-Host "No CSAR files found in $csarFolder" -ForegroundColor Yellow
    exit 0
}

foreach ($file in $csarFiles) {
    Write-Host "Running RecomputeHIPSGrid on $($file.FullName)"
    & $carisBatch --run RecomputeHIPSGrid "$($file.FullName)"
}

Write-Host "Done."
