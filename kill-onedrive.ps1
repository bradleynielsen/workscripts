Get-Process | Where-Object {$_.ProcessName -eq "OneDrive"} | Stop-Process

