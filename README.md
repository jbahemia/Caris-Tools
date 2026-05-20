Note I have created all these in standard windows batch file and powershell as sometimes IT restrict batches. they shouldnt need any additional packages and will run on IT controlled computers.
-------------------------------------

add_1a_compliance_bands.bat

This will add the IHO order 1a Position TPU and Depth TPU 'compliance' bands to SDTP surfaces in a folder with Depth TPU / Position TPU layers. Note that these are Allowable Uncertainty - Achieved Uncertainty so a negative number is a fail. You have to provide the BASE Editor batch exe file path in the code "carisBatch=C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"
-------------------------------------

clear_HIPS_line_locks.bat

This batch when directed to a folder containing multiple Caris HIPS projects will run the line lock clearing utility recursively through all the subfolders. It requires the user to specify the location of the HIPS parent folder and the full file path to the .exe "C:\Visual Studio Code\clear_HIPS_line_locks.exe" for example. It will then output the summary to a text file in the HIPS parent folder. The .exe file can also be found here and will need to be downloaded with it, it was made by Caris and provides the actual functionality
-------------------------------------

export_csar_to_geotiff.bat

This exports all csar in a folder to geotiff including bands specified by surface type. You have to provide the BASE Editor batch exe file path in the code "carisBatch=C:\Program Files\CARIS\BASE Editor\5.5\bin\carisbatch.exe"
-------------------------------------

extract_subarea_(CSAR_WKT).bat

This will use a boundary exported as Well Known Text (WKT) from Caris and clip a csar by it. Note it refers to geodesy in the WKT file to function so you cannot use a shape file. You can however export a shape file from Caris as a WKT. All bands will be included from the original
-------------------------------------
