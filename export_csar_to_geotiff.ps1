$type = Read-Host "Type CUBE or SDTP to select surface type"
$inputPath = Read-Host "Enter the path to a CSAR file or folder containing CSAR files"
# Remove quotes if present
$inputPath = $inputPath -replace '^[\"]*(.*?)[\"]*$', '$1'
$carisBatch = "C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"

if ($type.ToUpper() -eq "CUBE") {
    $bands = @("Depth", "Density", "Uncertainty")
    Write-Host "CUBE selected. Bands: $($bands -join ", ")"
} elseif ($type.ToUpper() -eq "SDTP") {
    $bands = @("Depth", "Density", "Depth_TPU")
    Write-Host "SDTP selected. Bands: $($bands -join ", ")"
} else {
    Write-Host "Invalid selection. Please run the script again and type CUBE or SDTP."
    exit
}



if (-not (Test-Path $inputPath)) {
    Write-Host "The path does not exist."
    Pause
    exit 1
}

if (Test-Path $inputPath -PathType Container) {
    # It's a directory, process all .csar files in the folder
    Get-ChildItem -Path $inputPath -Filter *.csar | ForEach-Object {
        $input = $_.FullName
        $output = [System.IO.Path]::ChangeExtension($input, ".tif")
        $bandArgs = $bands | ForEach-Object { "--include-band"; $_ }
        $args = @('--run', 'ExportRaster', '--output-format', 'GEOTIFF') + $bandArgs + @($input, $output)
        Write-Host "Processing $input to $output with bands: $($bands -join ", ")"
        & $carisBatch @args
    }
} elseif (Test-Path $inputPath -PathType Leaf) {
    # It's a file, process just that file
    $input = $inputPath
    $output = [System.IO.Path]::ChangeExtension($input, ".tif")
    $bandArgs = $bands | ForEach-Object { "--include-band"; $_ }
    $args = @('--run', 'ExportRaster', '--output-format', 'GEOTIFF') + $bandArgs + @($input, $output)
    Write-Host "Processing $input to $output with bands: $($bands -join ", ")"
    & $carisBatch @args
}

Write-Host "Done!"
Pause
