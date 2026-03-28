Connect-MsolService

$CurrentLicense = (Get-MsolAccountSku | Where-Object { $_.AccountSkuId -like "*current_sku*" }).AccountSkuId

$DesiredLicense = (Get-MsolAccountSku | Where-Object { $_.AccountSkuId -like "*desired_sku*" }).AccountSkuId

$users = import-csv "C:\path\to\userlist.csv" -delimiter ","

 foreach ($user in $users) 
    { 
        $upn=$user.UPN 
        Set-MsolUserLicense -UserPrincipalName $upn -RemoveLicenses $CurrentLicense -AddLicenses $DesiredLicense
    }  