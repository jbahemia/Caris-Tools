# Export CUBE CSAR to BAG - PowerShell version
$ErrorActionPreference = 'Stop'

Write-Host "Exporting CUBE surfaces only (Depth, Uncertainty bands)"
$folder = Read-Host "Enter the path to the folder containing CSAR files"

$carisBatch = 'C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe'

Get-ChildItem -Path $folder -Filter *.csar | ForEach-Object {
    $input = $_.FullName
    $basename = $_.BaseName
    $output = Join-Path $_.DirectoryName ("$basename.bag")
    Write-Host "Exporting raster: $input to $output with band Depth"
    & $carisBatch --run ExportRaster --output-format BAG --include-band Depth --uncertainty Uncertainty --abstract $basename --legal-constraints RESTRICTED --notes $basename --party-organization Cyan --security-constraints RESTRICTED --status COMPLETED --uncertainty-type PRODUCT_UNCERT --vertical-datum LAT --party-role PUBLISHER $input $output
}

Write-Host "Done!"
Pause
