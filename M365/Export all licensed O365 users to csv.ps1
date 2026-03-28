#Defines stored credential variable
$Cred = Get-Credential

#Establish connection to MS Online services using the previously defined and stored credential variable
Connect-MsolService -Credential $Cred

#Pull list of licensed users and export to a CSV displaying display name, UPN, City, Dept, and object ID to the currently defined directory path
Get-MsolUser -MaxResults 10000 | Where-Object { $_.isLicensed -eq "TRUE" } | Select DisplayName, UserPrincipalName, City, Department, ObjectID | Export-Csv -Path .\M365Users.csv -NoTypeInformation