$type = Read-Host "Type CUBE or SDTP to select surface type"
$folder = Read-Host "Enter the path to the folder containing CSAR files"
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


Get-ChildItem -Path $folder -Filter *.csar | ForEach-Object {
    $input = $_.FullName
    $output = [System.IO.Path]::ChangeExtension($input, ".tif")
    $bandArgs = $bands | ForEach-Object { "--include-band"; $_ }
    $args = @('--run', 'ExportRaster', '--output-format', 'GEOTIFF') + $bandArgs + @($input, $output)
    Write-Host "Processing $input to $output with bands: $($bands -join ", ")"
    & $carisBatch @args
}

Write-Host "Done!"
Pause
