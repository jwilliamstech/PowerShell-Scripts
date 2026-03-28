connect-mggraph -scopes "Directory.Read.All"

#Set X days for search
$dt = (Get-Date).AddDays(-782)

#Generate CSV reports of devices older than X days
Get-MgDevice -All:$true | Where {$_.ApproximateLastLogonTimeStamp -le $dt} | select-object -Property AccountEnabled, DeviceId, DeviceOSType, DeviceOSVersion, DisplayName, DeviceTrustType, ApproximateLastLogonTimestamp | export-csv devicelist-olderthan-90days-summary.csv -NoTypeInformation 

#Disable devices older than X days
$Devices = Get-MgDevice -All:$true | Where {$_.ApproximateLastLogonTimeStamp -le $dt}
foreach ($Device in $Devices) {
Set-MgDevice -ObjectId $Device.ObjectId -AccountEnabled $false
}

#Delete disabled devices older than X days
$Devices = Get-MgDevice -All:$true | Where {($_.ApproximateLastLogonTimeStamp -le $dt) -and ($_.AccountEnabled -eq $false)}
foreach ($Device in $Devices) {
Remove-MgDevice -ObjectId $Device.ObjectId
}