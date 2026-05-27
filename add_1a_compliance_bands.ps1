$carisBatch = "C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"


# Prompt user for CSAR folder or file path
$inputPath = Read-Host "Enter the path to your CSAR folder or a single CSAR file"
# Remove quotes if present
$inputPath = $inputPath -replace '^[\"]*(.*?)[\"]*$', '$1'



# Band 1 parameters
$band1Name = "Depth_TPU_Compliance"
$band1Expr = "(((0.5 ^ 2 + (0.013*Depth) ^ 2) ^ 0.5) - Depth_TPU)"
$band1Type = "Numeric"

# Band 2 parameters
$band2Name = "Position_TPU_Compliance"
$band2Expr = "((5 + (Depth * 0.05)) - Position_TPU)"
$band2Type = "Numeric"


if (-not (Test-Path $inputPath)) {
    Write-Host "The path does not exist."
    Read-Host "Press Enter to exit..."
    exit 1
}

if (Test-Path $inputPath -PathType Container) {
    # It's a directory, process all .csar files in the folder
    Get-ChildItem -Path $inputPath -Filter *.csar | ForEach-Object {
        $file = $_.FullName
        Write-Host "Processing: $file"
        & "$carisBatch" --run AddComputedBand --compute-band "$band1Name" --expression $band1Expr --z-axis-convention DOWN --computed-band-type $band1Type "$file"
        & "$carisBatch" --run AddComputedBand --compute-band "$band2Name" --expression $band2Expr --z-axis-convention DOWN --computed-band-type $band2Type "$file"
    }
} elseif (Test-Path $inputPath -PathType Leaf) {
    # It's a file, process just that file
    Write-Host "Processing: $inputPath"
    & "$carisBatch" --run AddComputedBand --compute-band "$band1Name" --expression $band1Expr --z-axis-convention DOWN --computed-band-type $band1Type "$inputPath"
    & "$carisBatch" --run AddComputedBand --compute-band "$band2Name" --expression $band2Expr --z-axis-convention DOWN --computed-band-type $band2Type "$inputPath"
}
