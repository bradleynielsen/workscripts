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

write "Extracting files"
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
        # rename and move file             
        $newName = "$zipName-$($_.Name)"
        $destinationPath = Join-Path $destinationFolder $newName
        Move-Item -Path $_.FullName -Destination $destinationPath -Force
    }
}

write "Cleaning up temp files"
# Cleanup temp folder (optional)
Remove-Item -Path $tempExtractPath -Recurse -Force

# get  files
$nessusFiles = (Get-ChildItem -Path $destinationFolder)


foreach ($nessusFile in $nessusFiles) {
    

    Write-Host "Fetching xml... " -NoNewline
    # get xml
    $NessusXML = [xml](Get-Content -Path $nessusFile.FullName)

    # get date
    $ScanEndTime = $NessusXML.NessusClientData_v2.Report.ReportHost.HostProperties.tag | Where-Object {$_.name -eq "HOST_END"} | Select-Object -ExpandProperty '#text'
    $InputFormat = "ddd MMM dd HH:mm:ss yyyy"
    
    #if there is a scan date:
    if ($ScanEndTime){
        try{
            $DateTimeObject = [datetime]::ParseExact($ScanEndTime, $InputFormat, $null)
        }catch{
            try{
                $DateTimeObject = [datetime]::ParseExact($ScanEndTime[0], $InputFormat, $null)
            }catch{
                Write-Host "Scan file blank" 
            }
        }
        $scanDate = $DateTimeObject.ToString("yyyy-MM-dd") 
    } else { #if no scan date:
        $scanDate = "NULL_SCAN_DATE"
    }

    #rename file
    write "Adding date to file"
    $NewFileName = $scanDate + "-" + $nessusFile.BaseName + ".nessus"
    Rename-Item -Path $nessusFile.FullName -NewName $NewFileName


}







