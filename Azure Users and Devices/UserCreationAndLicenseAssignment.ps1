<#
MS Graph User Commands

New-MgUser: Creates a new user. You must provide a display name, user principal name (UPN), mail nickname, and a password profile.
Get-MgUser: Retrieves user details to verify provisioning.
Update-MgUser: Updates existing user properties like job title or department.
Remove-MgUser: Deletes a user account.
Set-MgUserLicense: Assigns or removes Microsoft 365/Azure licenses (e.g., Mobility + Security E5).
New-MgGroupMember: Adds the new user to a specific security or M365 group.

#>

# Set Execution Policy
Set-ExecutionPolicy RemoteSigned -Force

# Install or Update PowerShellGet
Install-Module PowerShellGet -Force

# Install MS Graph Modules
Install-Module -Name Microsoft.Graph -Scope CurrentUser

# Connect to MS Graph and Set Scope for License SKU Retrieval and User Account Creation
Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All"

# Retrieve License SKU
Get-MgSubscribedSku -All | Select-Object SkuPartNumber, SkuId

# Import the CSV
$users = Import-Csv -Path "C:\path\to\users.csv"

# Define the License SkuId (e.g., for Microsoft 365 E5)
$skuId = "License-SKU-GUID"

foreach ($user in $users) {
    # Create the New User
    $passwordProfile = @{ Password = "TemporaryPassword123!"; ForceChangePasswordNextSignIn = $true }
    
    $newUser = New-MgUser -DisplayName $user.DisplayName `
                          -UserPrincipalName $user.UserPrincipalName `
                          -UsageLocation $user.UsageLocation `
                          -MailNickname $user.UserPrincipalName.Split('@')[0] `
                          -PasswordProfile $passwordProfile `
                          -AccountEnabled

    # Assign License
    if ($newUser) {
        $license = @{
            AddLicenses = @(@{ SkuId = $skuId })
            RemoveLicenses = @()
        }
        Set-MgUserLicense -UserId $newUser.Id -BodyParameter $license
    }
}