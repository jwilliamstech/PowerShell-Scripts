$ServerList = Get-Content "C:\temp\ServerList.txt"

foreach($Server in $ServerList) {
Get-WindowsFeature Remote-Desktop-Services -ComputerName $Server | Select-Object @{n='ServerName';e={$Server}},Installed
}

Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' } -Properties OperatingSystem | select -ExpandProperty Name | Out-File "C:\temp\ServerList.txt"