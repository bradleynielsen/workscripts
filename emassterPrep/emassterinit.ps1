###########################################################
# open ps1 in editor
# In the shell, navigate to the path whit th ZIP files
# then F5/run the script
###########################################################



# Set source directory containing zip files
$zipDirectory    = (Get-Location).path
$destinationFolder = Join-Path $zipDirectory "emasster"

# Create 'emasster' folder if it doesn't exist
if (-not (Test-Path $destinationFolder)) {
    New-Item -Path $destinationFolder -ItemType Directory
}

# Temporary folder for extraction
$tempExtractPath = Join-Path $zipDirectory "temp_extract"
if (-not (Test-Path $tempExtractPath)) {
    New-Item -Path $tempExtractPath -ItemType Directory
}

# Process each zip file
Get-ChildItem -Path $zipDirectory -Filter *.zip | ForEach-Object {
    $zipFile = $_
    $zipName = [System.IO.Path]::GetFileNameWithoutExtension($zipFile.Name)

    # Clear temp folder
    Remove-Item -Path "$tempExtractPath\*" -Force -Recurse -ErrorAction SilentlyContinue

    # Extract to temp
    Expand-Archive -Path $zipFile.FullName -DestinationPath $tempExtractPath -Force

    # Move and rename .nessus files
    Get-ChildItem -Path $tempExtractPath -Recurse -Filter *.nessus | ForEach-Object {
        $newName = "$zipName-$($_.Name)"
        $destinationPath = Join-Path $destinationFolder $newName
        Move-Item -Path $_.FullName -Destination $destinationPath -Force
    }
}

# Cleanup temp folder (optional)
Remove-Item -Path $tempExtractPath -Recurse -Force
