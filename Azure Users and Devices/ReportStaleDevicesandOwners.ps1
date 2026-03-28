#Report Stale Devices & Owners script, authored by Joshua Williams


connect-mggraph -scopes "Directory.Read.All"

#Define stale age of devices
$daysold = '-' + (Read-Host -prompt 'How many days since the last logon?')
$date = (Get-Date).AddDays($daysold)

#CSV export path
$path = "C:\temp\deviceList.csv"

#Store AAD devices older than X date
$deviceList = Get-MgDevice -All:$true | Where {$_.ApproximateLastLogonTimeStamp -le $date}

Write-host ('Running query now. This can take a few minutes. Please wait. ')

$devices = @()
    
 foreach($device in $deviceList){
     $deviceOwner = $device | Get-MgDeviceRegisteredOwner
     $deviceProps = [ordered] @{
         DeviceName = $device.DisplayName
         Enabled = $device.AccountEnabled
         OS = $device.DeviceOSType
         Version = $device.DeviceOSVersion
         JoinType = $device.DeviceTrustType
         Owner = $deviceOwner.DisplayName
         LastLogonTimestamp = $device.ApproximateLastLogonTimeStamp
     }
     $deviceObj = New-Object -Type PSObject -Property $deviceProps
     $devices += $deviceObj
 }
    
 $devices | Export-Csv -Path $path -NoTypeInformation -Append

Write-host ('The file is available at ' + ($path))

Read-Host -Prompt "Press Enter to exit"