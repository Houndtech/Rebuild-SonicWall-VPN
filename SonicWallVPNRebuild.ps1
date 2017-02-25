<#
.SYNOPSIS
    Rebuilds VPN to SonicWALL VPN after Windows build reset. 
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
#>
function Reset-SonicWallVpn {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$VPNAddress
    )
    
    
    begin {
        #Variables
$xml = "<MobileConnect><Port>443</Port></MobileConnect>"
$sourceXml=New-Object System.Xml.XmlDocument
$sourceXml.LoadXml($xml)


$CCProps = @{
Name = 'CC_Fiber_VPN';
ServerAddress = 'https://209.94.232.70:4433';
SplitTunneling = $true;
PluginApplicationID = 'SonicWALL.MobileConnect_cw5n1h2txyewy';
CustomConfiguration = $sourceXml
}

$SAProps = @{
Name = 'SA_Fiber_VPN';
ServerAddress = 'https://209.94.232.62:4433';
SplitTunneling = $true;
PluginApplicationID = 'SonicWALL.MobileConnect_cw5n1h2txyewy';
CustomConfiguration = $sourceXml
}
    }
    
    process {Remove-VpnConnection $CCProps.name -Force
Remove-VpnConnection $SAProps.name -Force

#reset Sonicwall application
Get-AppXPackage SonicWALL.MobileConnect -AllUsers |
Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}

#Recreate vpns
Add-VpnConnection @CCProps
Add-VpnConnection @SAProps

        
    }
    
    end { }
}