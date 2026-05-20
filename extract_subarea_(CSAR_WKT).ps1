# PowerShell script to batch extract sub-areas from CSAR files using matching WKT files
# Prompts for CSAR, WKT, and output folders, then runs CARIS batch for each match

# Prompt for folders
$csarDir = Read-Host "Enter the folder path containing CSAR files"
$wktDir = Read-Host "Enter the folder path containing WKT files"
$outDir = Read-Host "Enter the output folder for extracted surfaces"

# Path to carisbatch.exe
$carisBatch = "C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"

# Get all CSAR files
$csarFiles = Get-ChildItem -Path $csarDir -Filter *.csar

foreach ($csar in $csarFiles) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($csar.Name)
    $wktPath = Join-Path $wktDir ("$baseName.wkt")
    if (Test-Path $wktPath) {
        $outPath = Join-Path $outDir ("${baseName}_extracted.csar")
        Write-Host "Running ExtractCoverage for $baseName"
        & "$carisBatch" --run ExtractCoverage --geometry-file "$wktPath" --include-band ALL "$($csar.FullName)" "$outPath"
    } else {
        Write-Host "No matching WKT for $($csar.Name), skipping."
    }
}

Write-Host "Done."
Pause
