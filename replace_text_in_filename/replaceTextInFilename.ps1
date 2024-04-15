
$textToReplace   = "U-FOUO"    # <<< Old text to replace
$replacementText = "CUI"       # <<< New text

"updating files"


#file text replace
$list = ls -File -Recurse -Force

foreach ($file in $list){
    "Filename: "+$BaseName
    $BaseName  = ($file.BaseName).Replace($textToReplace, $replacementText)
    $extension = $file.extension
    $newName   = $BaseName+$extension
    $file | Rename-Item  -NewName $newName -ErrorAction SilentlyContinue 
    "Filename updated to: "+$newName
}



"updating folders"

#folder text replace
$list = ls -Directory -Recurse

foreach ($folder in $list){
    $newName = ($folder.name).Replace($textToReplace, $replacementText)
    if($folder.name -ne $newName){
        Rename-Item  -LiteralPath $folder.FullName -NewName $newName  -ErrorAction Stop 
    }
}