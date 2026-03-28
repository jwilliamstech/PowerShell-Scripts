$ServerList = Get-Content "C:\temp\ServerList.txt"

foreach($Server in $ServerList) {
Get-WindowsFeature XXX-XX-XXXXX -ComputerName $Server | Select-Object @{n='ServerName';e={$Server}},Installed
}