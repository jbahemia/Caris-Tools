# Caris Tools

A collection of Windows batch and PowerShell utilities for working with CARIS data.

These scripts were created using standard Windows batch files and PowerShell so they can run on IT-controlled computers without requiring extra packages.

## Included scripts

### `add_1a_compliance_bands.bat`
Adds IHO Order 1a Position TPU and Depth TPU compliance bands to SDTP surfaces in a folder that already contain Depth TPU and Position TPU layers.

### `clear_HIPS_line_locks.bat`
Recursively clears line locks in multiple CARIS HIPS projects within a folder and its subfolders.

### `export_csar_to_geotiff.bat`
Exports all `.csar` files in a folder to GeoTIFF, including bands specified by surface type.

**Important:** Update the script with the path to the CARIS BASE Editor batch executable, for example:

`carisBatch=C:\Program Files\CARIS\BASE Editor ...`

### `extract_subarea_(CSAR_WKT).bat`
Clips a CSAR using a boundary exported from CARIS as Well-Known Text (WKT).

**Note:** This depends on geodesy information in the WKT file, so you cannot use a shapefile directly.
