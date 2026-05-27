# PowerShell script to batch extract sub-areas from CSAR files using matching WKT files
# Prompts for CSAR, WKT, and output folders, then runs CARIS batch for each match

# Prompt for folders

$inputPath = Read-Host "Enter the path to a CSAR file or folder containing CSAR files"
$inputPath = $inputPath -replace '^[\"]*(.*?)[\"]*$', '$1'
$wktInput = Read-Host "Enter the path to a WKT file (for single CSAR) or folder containing WKT files"
$wktInput = $wktInput -replace '^[\"]*(.*?)[\"]*$', '$1'
$outDir = Read-Host "Enter the output folder for extracted surfaces"
$outDir = $outDir -replace '^[\"]*(.*?)[\"]*$', '$1'

# Path to carisbatch.exe
$carisBatch = "C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"

if (-not (Test-Path $inputPath)) {
    Write-Host "The path does not exist."
    Pause
    exit 1
}

$csarIsFolder = Test-Path $inputPath -PathType Container
$wktIsFolder  = Test-Path $wktInput  -PathType Container

if ($csarIsFolder -and $wktIsFolder) {
    # Folder of CSARs + folder of WKTs: match by base name
    Get-ChildItem -Path $inputPath -Filter *.csar | ForEach-Object {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
        $wktPath  = Join-Path $wktInput "$baseName.wkt"
        if (Test-Path $wktPath) {
            $outPath = Join-Path $outDir "${baseName}_extracted.csar"
            Write-Host "Running ExtractCoverage for $baseName"
            & "$carisBatch" --run ExtractCoverage --geometry-file "$wktPath" --include-band ALL "$($_.FullName)" "$outPath"
        } else {
            Write-Host "No matching WKT for $($_.Name), skipping."
        }
    }
} elseif ($csarIsFolder -and -not $wktIsFolder) {
    # Folder of CSARs + single WKT file: only process CSAR whose base name matches the WKT
    $wktBaseName = [System.IO.Path]::GetFileNameWithoutExtension($wktInput)
    $matched = $false
    Get-ChildItem -Path $inputPath -Filter *.csar | ForEach-Object {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
        if ($baseName -ieq $wktBaseName) {
            $outPath = Join-Path $outDir "${baseName}_extracted.csar"
            Write-Host "Running ExtractCoverage for $baseName (using single WKT)"
            & "$carisBatch" --run ExtractCoverage --geometry-file "$wktInput" --include-band ALL "$($_.FullName)" "$outPath"
            $matched = $true
        }
    }
    if (-not $matched) {
        Write-Host "No CSAR found matching WKT base name '$wktBaseName', skipping."
    }
} elseif (-not $csarIsFolder -and $wktIsFolder) {
    # Single CSAR + folder of WKTs: find matching WKT by base name
    $csar     = Get-Item $inputPath
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($csar.Name)
    $wktPath  = Join-Path $wktInput "$baseName.wkt"
    if (Test-Path $wktPath) {
        $outPath = Join-Path $outDir "${baseName}_extracted.csar"
        Write-Host "Running ExtractCoverage for $baseName"
        & "$carisBatch" --run ExtractCoverage --geometry-file "$wktPath" --include-band ALL "$($csar.FullName)" "$outPath"
    } else {
        Write-Host "No matching WKT for $($csar.Name), skipping."
    }
} else {
    # Single CSAR + single WKT file: process directly
    $csar     = Get-Item $inputPath
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($csar.Name)
    if (Test-Path $wktInput) {
        $outPath = Join-Path $outDir "${baseName}_extracted.csar"
        Write-Host "Running ExtractCoverage for $baseName"
        & "$carisBatch" --run ExtractCoverage --geometry-file "$wktInput" --include-band ALL "$($csar.FullName)" "$outPath"
    } else {
        Write-Host "WKT file not found: $wktInput"
    }
}

Write-Host "Done."
Pause
