$list = ls -File -Recurse

foreach ($file in $list){
    $BaseName = ($file.BaseName).Replace("."," ")
    $extension = $file.extension
    $newName      = $BaseName+$extension
    $file|Rename-Item  -NewName $newName -ErrorAction Continue 
}


$list = ls -Directory -Recurse
foreach ($folder in $list){
    $newName = ($folder.name).Replace("."," ")
    if($folder.name -ne $newName){
        Rename-Item  -LiteralPath $folder.FullName -NewName $newName  -ErrorAction Stop 
    }
}



explorer .




