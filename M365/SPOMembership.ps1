# Split path
$Path = Split-Path -Parent "C:\PS Report\*.*"

# Create variable for the date stamp in log file
$LogDate = Get-Date -f yyyyMMddhhmm

# Define CSV and log file location variables
# They have to be on the same location as the script
$Csvfile = $Path + "\SPO_SITE_USERS_$logDate.csv"

# Set distinguishedName as searchbase, you can use one OU or multiple OUs
# Or use the root domain like DC=tenant,DC=local
$Sites = Get-SPOSite -Limit ALL

# Create empty array
$SPOSiteUsers = @()

# Loop through every Site
foreach ($Site in $Sites) {
    Write-host "Checking Site Membership for:"$Site.URL
    $Users = (Get-SPOUser -site $Site)

    # Add users to array
    $SPOSiteUsers += $Users | Where {($_.DisplayName -NotLike "*Sharepoint*" -and $_.DisplayName -NotLike "*Guest Contributor*" -and $_.DisplayName -NotLike "*_spoc*" -and $_.DisplayName -NotLike "*spsearch*" -and $_.DisplayName -NotLike "*tenant*")} | Select-Object `
    @{Label = "Site" ; Expression = { $Site.URL } },
    @{Label = "DisplayName"; Expression = { $_.DisplayName } }
}

# Create list
$SPOSiteUsers | Sort-Object Site, DisplayName | Select-Object `
@{Label = "Site" ; Expression = { $_.Site } },
@{Label = "Display Name"; Expression = { $_.DisplayName } }|

# Export report to CSV file
Export-Csv -Encoding UTF8 -Path $Csvfile -NoTypeInformation #-Delimiter ";"