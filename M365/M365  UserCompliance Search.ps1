#Archive M365 User script, authored by Joshua Williams.

#Create variables to pass for O365 credentials
$AdminName = "username@domain.com"
#Could opt to enter password every time, but I have converted my password to hashed value and pass via the line below
$Pass = Get-Content "C:\Stored Credentials\Credentials.txt" | ConvertTo-SecureString
$UserCredential = new-object -typename System.Management.Automation.PSCredential -argumentlist $AdminName, $Pass

#Connect to Exchange Online Compliance Portal
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

#Create Variables for Use and Search Criteria
$Name = Read-Host "What is the user's first and last name?"
$userid = Read-Host "What is the user's ID?"
$UserIDAndDomain = "$userid" + "@domain.com" 
$SharePointURL = "https://domain-my.sharepoint.com/personal/" + "$userid" +"_domain_com"

#Create New Content Search for PST
New-ComplianceSearch -Name "$Name PST" -ExchangeLocation $UserIDAndDomain -AllowNotFoundExchangeLocationsEnabled $false

#Create New Content Search for OneDrive
New-ComplianceSearch -Name "$Name OneDrive" -SharePointLocation $SharePointURL

#Start New Content Searches
Start-ComplianceSearch -Identity "$Name PST"
Start-ComplianceSearch -Identity "$Name OneDrive"

#Wait command for search to process/complete (in seconds). Can probably be lowered but this is too ensure huge mailboxes have time to process.
Start-Sleep -s 1200

#Compliance Search action to export with desired settings
New-ComplianceSearchAction -SearchName "$Name PST" -Export -ExchangeArchiveFormat SinglePST -Format FXStream -Scope BothIndexedAndUnindexedItems
New-ComplianceSearchAction -SearchName "$Name OneDrive" -Export -SharePointArchiveFormat SingleZip -IncludeSharePointDocumentVersions $false -Scope BothIndexedAndUnindexedItems

#End powershell session
Remove-PSSession $Session

pause
