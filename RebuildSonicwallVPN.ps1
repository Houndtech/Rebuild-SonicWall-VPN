<#
.SYNOPSIS
    Rebuilds VPN to SonicWALL VPN after Windows build reset. 
.DESCRIPTION
    Captures the settings of any configured Sonicwall Mobile connect VPNs.
    Then removes the VPNs, resets the SonicWall Mobile Connect application, and rebuilds the VPNs with the saved settings
    No parameters are needed as the script stores the config settings in memory during execution.
.EXAMPLE
    ./RebuildSonicwallVPN.ps1
#>
 
 #Common Variables
$xml = "<MobileConnect><Port>443</Port></MobileConnect>"
$sourceXml=New-Object System.Xml.XmlDocument
$sourceXml.LoadXml($xml)

#Capture Existing Configurations
$vpnlist = Get-VpnConnection |Where-Object {$_.PluginApplicationID -like "SonicWALL.MobileConnect*"}

#clean out VPNs
ForEach ($VPN in $vpnlist) {
    Remove-VpnConnection $VPN.Name -Force
    } #End ForEach

#reset Sonicwall Mobile Connect
$Sonicwall = Get-AppXPackage SonicWALL.MobileConnect
Add-AppxPackage -DisableDevelopmentMode -Register "$($Sonicwall.InstallLocation)\AppXManifest.xml"

#Rebuild VPNs
ForEach ($VPN in $vpnList) {
    $Props = @{
        Name = $Vpn.Name;        
        ServerAddress = $VPN.ServerAddress;
        SplitTunneling = $VPN.SplitTunneling;
        PluginApplicationID = $Sonicwall.PackageFamilyName;
        CustomConfiguration = $sourceXml
        } #End Props
    Add-VpnConnection @Props  
    
} #End ForEach