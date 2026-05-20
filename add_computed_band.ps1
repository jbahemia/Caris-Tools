$carisBatch = "C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"

# Prompt user for CSAR folder path
$folder = Read-Host "Enter the path to your CSAR folder"


# Band 1 parameters
$band1Name = "DTPUC"
$band1Expr = "(((0.5 ^ 2 + (0.013*Depth) ^ 2) ^ 0.5) - Depth_TPU)"
$band1Type = "Numeric"

# Band 2 parameters
$band2Name = "PTPUC"
$band2Expr = "((5 + (Depth * 0.05)) - Position_TPU)"
$band2Type = "Numeric"

Get-ChildItem -Path $folder -Filter *.csar | ForEach-Object {
    $file = $_.FullName


    # Add first computed band
    $cmd1 = '"' + $carisBatch + '" --run AddComputedBand --compute-band "' + $band1Name + '" --expression ' + $band1Expr + ' --z-axis-convention UP --computed-band-type ' + $band1Type + ' "' + $file + '"'
    Write-Host "Running: $cmd1"
    & "$carisBatch" --run AddComputedBand --compute-band "$band1Name" --expression $band1Expr --z-axis-convention DOWN --computed-band-type $band1Type "$file"

    # Add second computed band
    $cmd2 = '"' + $carisBatch + '" --run AddComputedBand --compute-band "' + $band2Name + '" --expression ' + $band2Expr + ' --z-axis-convention UP --computed-band-type ' + $band2Type + ' "' + $file + '"'
    Write-Host "Running: $cmd2"
    & "$carisBatch" --run AddComputedBand --compute-band "$band2Name" --expression $band2Expr --z-axis-convention DOWN --computed-band-type $band2Type "$file"
}
