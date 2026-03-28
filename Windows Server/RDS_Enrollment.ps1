<#
This script configures and enables domain-joined Windows systems for Remote Desktop Services. You will need your licensing server 
information to proceed. Set variables to indicated in order to run.
#>

$LicSvrRegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\TermService\Parameters\LicenseServers'
$LicSvrName         = 'ServerName'
$LicSvrValue        = 'licensingserver.ad.domain.com'

$TermSvcRegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
$TermSvcName         = 'LicenseServers'
$TermSvcValue        = 'licensingserver.ad.domain.com'

$LicCoreRegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\Licensing Core'
$LicCoreName         = 'LicensingMode'
$LicCoreValue        = '4'

# Create the License Servers key if it does not exist
If (-NOT (Test-Path $LicSvrRegistryPath)) {
  New-Item -Path $LicSvrRegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $LicSvrRegistryPath -Name $LicSvrName -Value $LicSvrValue -PropertyType String -Force

# Create the Terminal Services key if it does not exist
If (-NOT (Test-Path $TermSvcRegistryPath)) {
  New-Item -Path $TermSvcRegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $TermSvcRegistryPath -Name $TermSvcName -Value $TermSvcValue -PropertyType String -Force

# Create the License Core key if it does not exist
If (-NOT (Test-Path $LicCoreRegistryPath)) {
  New-Item -Path $LicCoreRegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $LicCoreRegistryPath -Name $LicCoreName -Value $LicCoreValue -PropertyType DWORD -Force

Restart-Service -Force -DisplayName "Remote Desktop Services"