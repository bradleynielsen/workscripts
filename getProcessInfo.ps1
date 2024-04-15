$filePath    = 'c:\temp'
$csvFileName = 'runningprocesses.csv'
$csvPath     = $filePath +'\'+ $csvFileName

try{
    mkdir $filePath -ErrorAction Stop
    "Making c:\temp"
}catch{
    "temp exists"
}

Get-Process | Select-Object Name,` Path, Description, FileVersion, Product| Export-Csv -Path $csvPath -NoTypeInformation
"saving to c:\temp\runningprocesses.csv"
explorer $filePath 