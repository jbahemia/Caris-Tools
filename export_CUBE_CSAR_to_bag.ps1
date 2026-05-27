# Export CUBE CSAR to BAG - PowerShell version
$ErrorActionPreference = 'Stop'


Write-Host "Exporting CUBE surfaces only (Depth, Uncertainty bands)"
$inputPath = Read-Host "Enter the path to a CSAR file or folder containing CSAR files"
# Remove quotes if present
$inputPath = $inputPath -replace '^[\"]*(.*?)[\"]*$', '$1'

$carisBatch = 'C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe'


if (-not (Test-Path $inputPath)) {
    Write-Host "The path does not exist."
    Pause
    exit 1
}

if (Test-Path $inputPath -PathType Container) {
    # It's a directory, process all .csar files in the folder
    Get-ChildItem -Path $inputPath -Filter *.csar | ForEach-Object {
        $input = $_.FullName
        $basename = $_.BaseName
        $output = Join-Path $_.DirectoryName ("$basename.bag")
        Write-Host "Exporting raster: $input to $output with band Depth"
        & $carisBatch --run ExportRaster --output-format BAG --include-band Depth --uncertainty Uncertainty --abstract $basename --legal-constraints RESTRICTED --notes $basename --party-organization Cyan --security-constraints RESTRICTED --status COMPLETED --uncertainty-type PRODUCT_UNCERT --vertical-datum LAT --party-role PUBLISHER $input $output
    }
} elseif (Test-Path $inputPath -PathType Leaf) {
    # It's a file, process just that file
    $input = $inputPath
    $basename = [System.IO.Path]::GetFileNameWithoutExtension($input)
    $output = [System.IO.Path]::ChangeExtension($input, ".bag")
    Write-Host "Exporting raster: $input to $output with band Depth"
    & $carisBatch --run ExportRaster --output-format BAG --include-band Depth --uncertainty Uncertainty --abstract $basename --legal-constraints RESTRICTED --notes $basename --party-organization Cyan --security-constraints RESTRICTED --status COMPLETED --uncertainty-type PRODUCT_UNCERT --vertical-datum LAT --party-role PUBLISHER $input $output
}

Write-Host "Done!"
Pause
